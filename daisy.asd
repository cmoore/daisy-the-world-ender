;;;; daisy.asd

(asdf:defsystem #:daisy
  :serial t
  :description "Describe daisy here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (:hunchentoot
               :cl-who
               :parenscript
               :cl-ivy)
  :components ((:file "package")
               (:file "daisy")))

