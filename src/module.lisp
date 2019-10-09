
(in-package dithcord)

(defvar *known-modules* (make-hash-table))

(defstruct module
  depends
  handlers)

(defmacro define-module (name &key depends)
  "Define a module. Note that modules are strictly single-instance per
lisp-system so you're free to use global variables to store
module-specific data."
  (let ((module (make-module :depends depends
                             :handlers (make-hash-table))))
    (setf (gethash name *known-modules*) module)
    `',name))

;;;; INTERNAL

(defun get-module (module-name)
  (gethash module-name *known-modules*))

(defun load-module (bot module-name)
  ;; Skip loading module if it's already loaded
  (unless (member module-name (bot-loaded-modules bot))
    (let ((module (get-module module-name)))
      (call-module-handler module :on-module-init nil)
      ;; Modules are ordered in the LOADED-MODULES list by
      ;; dependencies so lower-level modules' handlers are
      ;; called first.
      (alexandria:appendf (bot-loaded-modules bot) (list module-name)))))
