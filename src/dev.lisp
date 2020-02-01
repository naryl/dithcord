
(in-package dithcord)

(defparameter declaim-optimize
    #-release-build (declaim (optimize debug safety))
    #+release-build (declaim (optimize speed)))

(defun deliver (filename)
  (sb-ext:save-lisp-and-die filename :executable t))
