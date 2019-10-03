
(in-package dithcord)

(defun message-create (msg)
  (unless (lc:botp (lc:author msg)) ; short out if the author is a bot
    ;; If the command was invoked via an @mention, we want to get rid of
    ;; that as well as any surrounding whitespace
    ;; #'ME simply returns the user-instance of the current bot
    (let ((cmd (string-trim " " (lispcord:remove-mention (lispcord:me) (lc:content msg)))))
      (cond ((string= cmd "ping!")
             (let ((now (get-internal-real-time))
                   (reply (lispcord:reply msg "pong!"))
                   (then (get-internal-real-time)))
               (lispcord:edit (format nil "Message took: ~a ms" (- then now))
                              reply)))
            ((string= cmd "bye!")  (lispcord:disconnect lispcord:*client*))))))

(defun start (token)
  (setf lispcord:*client* (lispcord:make-bot token :version "0.0.1"))
  (lispcord:connect lispcord:*client*)
  (lispcord:add-event-handler :on-message-create 'message-create))

(defun stop ()
  (lispcord:disconnect lispcord:*client*))
