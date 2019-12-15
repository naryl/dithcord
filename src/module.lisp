
(in-package dithcord)

#.declaim-optimize

(defvar *known-modules* (make-hash-table))

(defparameter *special-events*
  (list :on-module-load))

(defstruct module
  depends
  handlers)

(defmacro define-module (name (&rest depends))
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
      ;; Ensure dependencies are loaded first
      (unless module
        (error "Loading undefined module: ~A" module-name))
      (dolist (dep (module-depends module))
        (load-module bot dep))
      ;; Do module-specific initialization
      (call-module-handler module :on-module-load nil)
      ;; Ensure there's a registered Lispcord handler which will
      ;; forward its events to Dithcord modules for each event this
      ;; module handles
      (dolist (event (alexandria:hash-table-keys (module-handlers module)))
        (ensure-lispcord-handler event))
      ;; Modules are ordered in the LOADED-MODULES list by
      ;; dependencies so lower-level modules' handlers are
      ;; called first.
      (alexandria:appendf (bot-loaded-modules bot) (list module-name)))))

(defun unload-module (bot module-name)
  ;; Skip unloading module if it's not loaded
  (when (member module-name (bot-loaded-modules bot))
    (let ((module (get-module module-name)))
      ;; Ensure depending modules are unloaded first
      (dolist (mod (bot-loaded-modules bot))
        (when (member module-name (module-depends (get-module mod)))
          (v:warn :dithcord.modules "Unloading module ~A depending on ~A"
                  mod module-name)
          (unload-module bot mod)))
      ;; Do module-specific uninitialization
      (call-module-handler module :on-module-unload nil)
      ;; Leave Lispcord handler in place, we don't care
      
      ;; Remove the module from loaded modules list
      (alexandria:deletef (bot-loaded-modules bot) module-name))))
