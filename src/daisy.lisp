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

(defun rebuild-javascript ()
  (write-javascript)
  (compile-javascript))

(defun compile-javascript ()
   (trivial-shell:shell-command
   "npm install && ./node_modules/browserify/bin/cmd.js init.js -o bundle.js"))

(defun write-javascript ()
  (with-open-file (str "index.js"
                       :direction :output
                       :if-exists :rename
                       :if-does-not-exist :create)
    (format str (new-js))))

(defun load-game ()
;  (write-javascript)
;  (compile-javascript)
  (cl-who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent nil)
    (htm
     (:html
       (:body
         (:div :id "container" :style "width:800px;height:600px;")
         (:script :src "/bundle.js"))))))

