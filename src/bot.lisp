
(in-package dithcord)

#.declaim-optimize

(defvar *bots* (make-hash-table))
(defvar *current-bot* nil)

(defstruct bot
  (token nil)
  (selfbot nil)
  modules
  loaded-modules)

(defmacro define-bot (name (&rest modules) &key token auth selfbot)
  "Define a bot.
NAME is only used for START-BOT and STOP-BOT.
TOKEN is the bot's Discord token.
AUTH is a user's email and password as a pair. Use either this or TOKEN.
SELFBOT will make it introduce itself as a user account.
MODULES is the list of module names required for this module. If
    modules depend on each other then they may be loaded in a
    different order."
  (cond ((and token auth)
         (error "Use one of AUTH or TOKEN"))
        ((and auth (not selfbot))
         (error "AUTH can only be used if you're making a selfbot"))
        (token
         `(ensure-bot ',name ,token ',modules ,selfbot))
        ((and auth
              (listp auth)
              (= 2 (length auth)))
         `(ensure-bot ',name (get-user-token ,@auth) ',modules ,selfbot))
        (t (error "Use one of AUTH or TOKEN"))))

(define-setf-expander token (bot &environment env)
  (multiple-value-bind (temps vals new-val setter getter)
      (get-setf-expansion bot env)
    (declare (ignore new-val setter))
    (alexandria:with-gensyms (store)
      (values temps
              vals
              `(,store)
              `(progn
                 (setf (bot-token (gethash ',getter *bots*)) ,store)
                 ,store)
              `(bot-token ,getter)))))

(defun ensure-bot (name token modules selfbot)
  (if (and (gethash name *bots* nil)
           (eq (gethash name *bots*) *current-bot*))
      (update-bot name token modules selfbot)
      (create-bot name token modules selfbot)))

(defun create-bot (name token modules selfbot)
  (let ((bot (make-bot :token token :modules modules :selfbot selfbot)))
        (setf (gethash name *bots*) bot)
        name))

(defun update-bot (name token modules selfbot)
  (let ((bot (gethash name *bots*)))
    (setf (bot-token bot) token)
    (setf (bot-selfbot) selfbot)
    (setf (bot-modules bot) modules)
    (let ((remove-modules (set-stable-difference (bot-loaded-modules bot) modules))
          (add-modules (set-stable-difference modules (bot-loaded-modules bot))))
      (when remove-modules
        (v:info :dithcord "Removing no longer needed modules: ~A" remove-modules)
        (mapcar (lambda (mod) (unload-module bot mod))
                remove-modules))
      (when add-modules
        (v:info :dithcord "Adding new modules: ~A" add-modules)
        (mapcar (lambda (mod) (load-module bot mod))
                add-modules)))))

(defun start-bot (bot-name)
  "Start the bot named BOT-NAME. Note that even though there may be
several registered bots you can't start more than one bot per
lisp-system."
  (when lispcord:*client*
    (error "A bot is already running"))
  (let ((success nil))
    (unwind-protect
         (let ((bot (gethash bot-name *bots*)))
           (setf lispcord:*client* (lispcord:make-bot (bot-token bot) :selfbot (bot-selfbot bot)))
           (setf *current-bot* bot)
           (dolist (mod (bot-modules bot))
             (load-module bot mod))
           (lispcord:connect lispcord:*client*)
           (setf success t))
      ;; Set it back to nil if something breaks before LISPCORD:CONNECT
      (unless success
        (setf *current-bot* nil)
        (setf lispcord:*client* nil)))
    success))

(defun stop-bot ()
  "Stop the current bot. Modules won't be destroyed."
  (unless lispcord:*client*
    (error "No bot running"))
  (lispcord:disconnect lispcord:*client*)
  (setf *current-bot* nil)
  (setf lispcord:*client* nil))
