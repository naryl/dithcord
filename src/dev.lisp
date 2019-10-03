
(in-package dithcord)

(defmacro p (str &rest args)
  #+cooperative-debug `(v:debug :cl-cooperative ,str ,@args)
  #-cooperative-debug nil)

(defun deliver (filename)
  (sb-ext:save-lisp-and-die filename :executable t))
