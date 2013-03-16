
(in-package :daisy)

(defun game-js ()
  (setf (hunchentoot:content-type*) "application/javascript")
  (ps
   (defvar honk "")))
