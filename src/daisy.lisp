;;;; daisy.lisp

(in-package :daisy)

(defparameter *acceptor* nil)

(defun start-server (&key (port 8080))
  (setq *acceptor*
        (make-instance 'hunchentoot:easy-acceptor
                                   :document-root (cl-ivy:resource-path ".")
                                   :port port))
  (hunchentoot:start *acceptor*))

(defun stop-server ()
  (hunchentoot:stop *acceptor*))

(setq hunchentoot:*dispatch-table*
      (list
       (hunchentoot:create-regex-dispatcher "^/$" 'load-game)))

(defun regen-js ()
  (game-js)
  (trivial-shell:shell-command "npm install && ./node_modules/browserify/bin/cmd.js init.js -o bundle.js"))

(defun load-game ()
;  (regen-js)
  (cl-who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent nil)
    (htm
     (:html
       (:body
         (:script :src "/bundle.js")
         (:div :id "container" "Honk!")
         (:div :id "status"))))))

