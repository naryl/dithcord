
(in-package dithcord)

#.declaim-optimize

(defvar *bots* (make-hash-table))
(defvar *current-bot*)

(defstruct bot
  token
  modules
  loaded-modules)

(defmacro define-bot (name (&rest modules) &key token)
  "Define a bot.
NAME is only used for START-BOT and STOP-BOT.
TOKEN is the bot's Discord token.
MODULES is the list of module names required for this module. If
    modules depend on each other then they may be loaded in a
    different order."
  `(ensure-bot ',name ,token ',modules))

(defun ensure-bot (name token modules)
  (let ((bot (make-bot :token token :modules modules)))
    (setf (gethash name *bots*) bot)
    name))

(defmacro start-bot (bot-name)
  `(start-bot-impl ',bot-name))

(defun start-bot-impl (bot-name)
  "Start the bot named BOT-NAME. Note that even though there may be
several registered bots you can't start more than one bot per
lisp-system."
  (when lispcord:*client*
    (error "A bot is already running"))
  (let ((success nil))
    (unwind-protect
         (let ((bot (gethash bot-name *bots*)))
           (setf lispcord:*client* (lispcord:make-bot (bot-token bot)))
           (setf *current-bot* bot)
           (dolist (mod (bot-modules bot))
             (load-module bot mod))
           (lispcord:connect lispcord:*client*)
           (setf success t))
      ;; Set it back to nil if something breaks before LISPCORD:CONNECT
      (unless success
        (setf *current-bot* nil
              lispcord:*client* nil)
        ))
    success))

(defun stop-bot ()
  "Stop the current bot. Modules won't be destroyed."
  (unless lispcord:*client*
    (error "No bot running"))
  (lispcord:disconnect lispcord:*client*)
  (setf lispcord:*client* nil))
