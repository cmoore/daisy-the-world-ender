
(in-package :daisy)

(defun new-js ()
  (ps
    (defvar create-game (require "voxel-engine"))
    (defvar highlight (require "voxel-highlight"))
    
    (defvar game (create-game (create generate (aref (@ (require "voxel") generator) "Hill")
                                      cube-size 25
                                      world-origin (array 0 0 0)
                                      materials (array (array "grass" "dirt" "grass_dirt")
                                                       "obsidian"
                                                       "brick"
                                                       "grass"
                                                       "plank"))))

    (setf window.game game)
    
    (game.append-to "#container")
    (defvar create-player ((require "voxel-player") game))
    (defvar substack (create-player "/img/substack.png"))
    ((@ substack yaw position set) 2 14 4)
    (substack.possess)



    ; Highlight
    (defvar hl (highlight game (create color 0x00ff00
                                       distance 2
                                       adjacent-animate t)))
    (setf game.highlighter hl)
    (defvar block-pos-place nil)
    (defvar block-pos-erase nil)
    (defvar current-material 1)
    
    ((@ hl on) "highlight" (lambda (voxel-pos)
                             (setf block-pos-erase voxel-pos)))
    ((@ hl on) "remove" (lambda (vp)
                          (setf block-pos-erase nil)))
    ((@ hl on) "highlight-adjacent" (lambda (vp)
                                      (setf block-pos-place vp)))
    ((@ hl on) "remove-adjacent" (lambda (vp)
                                   (setf block-pos-place nil)))



    
    (game.on "fire" (lambda (target state)
                      (defvar position block-pos-place)
                      (if position
                          ((@ game create-block) position current-material)
                          (progn
                            (setf position block-pos-erase)
                            (when position
                              ((@ game set-block) position 0))))
                      t))))

(defun game-js ()
  (ps
    (defvar create-game (require "voxel-engine"))
    (defvar highlight (require "voxel-highlight"))
    (defvar player (require "voxel-player"))
    (defvar voxel (require "voxel"))
    (defvar extend (require "extend"))

    (defvar t_chunk_size 2)
    (defvar t_chunk_distance 32)

    (defvar terrain (require "voxel-perlin-terrain"))
    (defvar t_generator (terrain
                         (create chunk-distance t_chunk_distance
                                 chunk-size t_chunk_size
                                 scale-factor (/ (* t_chunk_distance t_chunk_size) 3))))

    (defvar t_make_tree (require "voxel-forest"))

    (setf module.exports
          (lambda (opts)
                        
            (defvar game (create-game
                          (create generate (aref (@ (require "voxel") generator) "Hill")
                                  cube-size 5
                                  world-origin (array 0 0 0)
                                  materials (array (array "grass" "dirt" "grass_dirt")
                                                   "obsidian"
                                                   "brick"
                                                   "grass"
                                                   "plank"))))
            (setf window.game game)
            ((@ game append-to) document.body)

            (defvar create-player (player game))
            (defvar substack (create-player "player.png"))

            (substack.posess)

            ((@ substack yaw position set) 2 14 4)

            (defvar block-pos-place nil)
            (defvar block-pos-erase nil)

            (defvar hl (highlight game (create color 0x00ff00
                                               distance 20
                                               adjacent-animate t)))

            (setf game.highlighter hl)

            ((@ hl on) "highlight" (lambda (voxel-pos)
                                     (setf block-pos-erase voxel-pos)
                                     nil))
            ((@ hl on) "remove" (lambda (vp)
                                  (setf block-pos-erase nil)
                                  nil))

            ((@ hl on) "highlight-adjacent" (lambda (vp)
                                              (setf block-pos-place vp)
                                              nil))

            ((@ hl on) "remove-adjacent" (lambda (vp)
                                           (setf block-pos-place nil)
                                           nil))


            ((@ window add-event-listener) "keydown"
             (lambda (ev)
               (if (= (@ ev key-code) ((@ "R" char-code-at) 0))
                   (substack.toggle))
               t))

            (defvar current-material 1)

            (defvar t_snow ((require "voxel-snow") (create game game
                                                           count 1000
                                                           size 20
                                                           speed 0.1
                                                           drift 1)))

            (game.on "tick" (lambda ()
                              (t_snow.tick)))
            (game.on "fire" (lambda (target state)
                              (defvar position block-pos-place)
                              (if position
                                  ((@ game create-block) position current-material)
                                  (progn
                                    (setf position block-pos-erase)
                                    (when position
                                      ((@ get set-block) position 0))))
                              t))
            game))))
