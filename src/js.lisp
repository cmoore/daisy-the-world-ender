
(in-package :daisy)

(defun game-js ()
  (with-open-file (str "index.js"
                       :direction :output
                       :if-exists :overwrite
                       :if-does-not-exist :create)
    (format str
            (string
             (ps
               (defvar t_game (require "voxel-engine"))
               (defvar t_highlight (require "voxel-highlight"))
               (defvar t_player (require "voxel-player"))
               (defvar t_texture_path_x (require "painterly-textures"))
               (defvar t_texture_path (t_texture_path_x __dirname))
               (defvar t_voxel (require "voxel"))
               (defvar t_extend (require "extend"))

               (defvar t_chunk_size 2)
               (defvar t_chunk_distance 32)

               (defvar terrain (require "voxel-perlin-terrain"))
               (defvar t_generator (terrain (create chunk-distance t_chunk_distance
                                                    chunk-size t_chunk_size
                                                    scale-factor (/ 3 (* t_chunk_distance t_chunk_size)))))

               (defvar t_make_tree (require "voxel-forest"))

               (setf module.exports (lambda (opts)
                                      (defvar defaults (create generate-voxel-chunk t_generator
                                                               cube-size 25
                                                               chunk-size t_chunk_size
                                                               chunk-distance t_chunk_distance
                                                               world-origin (array 0 0 0)
                                                               materials (array (array "grass" "dirt" "grass_dirt")
                                                                                "obsidian"
                                                                                "brick"
                                                                                "grass"
                                                                                "plank")
                                                               starting-position (array 0 0 0)
                                                               texture-path t_texture_path
                                                               controls (create discrete-fire t
                                                                                jump 4)))
                                      (setf opts (extend (create) defaults (or opts (create))))

                                      (defvar game (create-game opts))
                                      (setf window.game game)
                                      (defvar container (or opts.container document.body))

                                      ((@ game append-to) container)

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
                                                               (setf block-pos-erase voxel-pos)))
                                      ((@ hl on) "remove" (lambda (vp)
                                                            (setf block-pos-erase nil)))

                                      ((@ hl on) "highlight-adjacent" (lambda (vp)
                                                                        (setf block-pos-place vp)))

                                      ((@ hl on) "remove-adjacent" (lambda (vp)
                                                                     (setf block-pos-place nil)))


                                      ((@ window add-event-listener) "keydown" (lambda (ev)
                                                                                 (when (= (@ ev key-code) ((@ "R" char-code-at) 0))
                                                                                   ((@ substack toggle)))))


                                      game)))))))
