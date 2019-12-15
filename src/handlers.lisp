
(in-package dithcord)

#.declaim-optimize

(defmacro define-handler (module-name event (&rest args) &body body)
  "Define this module's handler for EVENT."
  (declare (type symbol module-name event))
  (alexandria:with-gensyms (module-g)
    `(let ((,module-g (get-module ',module-name)))
       (unless ,module-g
         (error "Module undefined: ~A" ,module-g))
       ;; Remove the handler if the body is empty
       ,@(if (null body)
             `((remhash ,event (module-handlers ,module-g)))
             `((setf (gethash ,event (module-handlers ,module-g))
                     (lambda ,args
                       ,@body))))
       '(,module-name ,event)
       ;; Defining a handler for the running bot
       (if (and *current-bot*
                (member ',module-name (bot-loaded-modules *current-bot*)))
           (ensure-lispcord-handler ,event)))))

;;;; INTERNAL

(defun call-module-handler (module handler-name data)
  "Call a module's handler with data if it exists."
  (let ((handler (gethash handler-name (module-handlers module) nil)))
    (when handler
      (with-simple-restart (skip-handler "Skip processing this handler.")
        (apply handler data)))))

(defun call-handler (handler data)
  "Call handler on every module in the current bot."
  (dolist (mod-name (bot-loaded-modules *current-bot*))
    (let ((module (get-module mod-name)))
      (call-module-handler module handler data))))

(defun ensure-lispcord-handler (name)
  "Ensure a handler is registered with Lispcord which will call
Dithcord's module handlers"
  (unless (member name *special-events*)
    (let ((handler-sym (alexandria:format-symbol 'dithcord.handlers "~A~A" name "-HANDLER")))
      (unless (fboundp handler-sym)
        (v:debug :dithcord.handlers "Registering Lispcord handler ~A" handler-sym)
        (setf (symbol-function handler-sym)
              (lambda (&rest data)
                (call-handler name data)))
        (lispcord:add-event-handler name handler-sym)))))
