
(in-package dithcord)

(defparameter declaim-optimize
    #+debug-build (declaim (optimize (debug 3) (safety 3) (speed 0) (size 0)))
    #-debug-build (declaim (optimize (speed 3))))

(defun deliver (filename)
  (sb-ext:save-lisp-and-die filename :executable t))
