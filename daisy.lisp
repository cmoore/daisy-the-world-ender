;;;; daisy.lisp

(in-package #:daisy)

;;; "daisy" goes here. Hacks and glory await!

(defparameter *acceptor* nil)

(defun start-server (&key (port 8080))
  (setq *acceptor*
        (make-instance 'hunchentoot:easy-acceptor
                                   :document-root (truename ".")
                                   :port port))
  (hunchentoot:start *acceptor*))

(setq hunchentoot:*dispatch-table*
      (list
       (hunchentoot:create-regex-dispatcher "^/js$" 'game-js)
       (hunchentoot:create-regex-dispatcher "^/$" 'load-game)))


(defun load-game ()
  (cl-who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent nil)
    (htm
     (:html
       (:body
         (:div "Honk!"))))))


(defun game-js ()
  (setf (hunchentoot:content-type*) "application/javascript")
  (ps
    (defvar honk "")))


