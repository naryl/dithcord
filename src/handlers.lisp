
(in-package dithcord)

(defmacro define-handler (module-name event (&rest args) &body body)
  "Define this module's handler for EVENT."
  (let ((module (get-module module-name)))
    (assert module)
    (setf (gethash event (module-handlers module))
          `(lambda ,args
             ,body))
    `'(,module-name ,event)))

;;;; INTERNAL

(defun call-module-handler (module handler-name data)
  "Call a module's handler with data if it exists."
  (let ((handler (gethash handler-name (module-handlers module) nil)))
    (when handler
      (apply handler data))))

(defun call-handler (handler data)
  "Call handler on every module in the current bot."
  (dolist (mod-name (bot-loaded-modules *current-bot*))
    (let ((module (get-module mod-name)))
      (call-module-handler module handler data))))

(defun ensure-lispcord-handler (name)
  "Ensure a handler is registered with Lispcord which will call
Dithcord's module handlers"
  (let ((handler-sym (alexandria:format-symbol 'dithcord.handlers "~A~A" name "-HANDLER")))
    (unless (fboundp handler-sym)
      (setf (symbol-function handler-sym)
            (lambda (&rest data)
              (call-handler name data)))
      (lispcord:add-event-handler name handler-sym))))
