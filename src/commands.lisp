
(in-package dithcord.commands)

#.dithcord::declaim-optimize

(defvar *commands* (make-hash-table :test 'equal))

(defun make-key (command)
  (string-downcase (string command)))

(defmacro define-command (module command (&rest args) &body body)
  (let ((key (make-key command)))
    (unless (gethash key *commands* nil)
      (setf (gethash key *commands*) (make-hash-table)))
    `(setf (gethash ',module (gethash ,(make-key command) *commands*))
           (lambda (,@args) ,@body))))

(dithcord:define-module commands ())

(dithcord:define-handler commands :on-message-create (msg)
  ;; Not received from a bot
  (unless (lc:botp (lc:author msg))
    ;; Starts with a command prefix
    (let* ((prefix (dithcord::bot-command-prefix dithcord::*current-bot*))
           (msg-prefix (subseq (lc:content msg) 0 (length prefix))))
      (when (equal msg-prefix prefix)
        (let* ((tokens (split-sequence:split-sequence #\Space (lc:content msg)))
               (command (make-key (subseq (first tokens) 1)))
               (args (rest tokens)))
          (maphash (lambda (module-name func)
                     ;; The module which registered this command is running
                     (when (member module-name
                                   (dithcord::bot-loaded-modules dithcord::*current-bot*))
                       (apply func msg args)))
                   (gethash command *commands* (make-hash-table))))))))
