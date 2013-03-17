

(ql:quickload 'daisy)
(ql:quickload 'swank)
(swank:create-server :port 4000 :dont-close t)

(in-package :daisy)
(start-server)


