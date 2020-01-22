
(in-package dithcord.modules)

#.dithcord::declaim-optimize

(defvar *commands* (make-hash-table :test 'equal))
(defvar *command-prefix* nil)

(defun make-key (command)
  (string-downcase (string command)))

(defun set-command-prefix (character)
  ;; Clear the prefix table first
  (setf *command-prefix* character)
  (setf lispcord::*cmd-prefix-table* (make-hash-table))
  (lispcord:make-prefix character))

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
    ;; A command
    (when (lispcord:commandp msg)
      ;; Remove mentions of me
      (setf msg (lispcord:remove-mention (lispcord:me) msg))
      (let* ((tokens (split-sequence:split-sequence #\Space (lc:content msg)))
             (command (make-key (if (eql (elt command 0) *command-prefix*)
                                    (subseq (first tokens) 1)
                                    (first tokens))))
             (args (rest tokens)))
        (maphash (lambda (module-name func)
                   ;; The module which registered this command is running
                   (when (member module-name
                                 (dithcord::bot-loaded-modules dithcord::*current-bot*))
                     (apply func msg args)))
                 (gethash command *commands* (make-hash-table)))))))
