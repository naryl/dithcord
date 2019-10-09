
(in-package dithcord-user)

(defvar token "asdf")

(define-bot echo-bot (echo)
    :token token
    ;; Modules are not loaded until the bot is started so we can define it after the bot
    )

(define-module echo)

;; Dithcord has some special events and the rest (like :on-message-create) are the same as Lispcord's
(define-handler echo :on-message-create (msg)
  (unless (lc:botp (lc:author msg))
    (let ((cmd (string-trim " " (lispcord:remove-mention (lispcord:me) (lc:content msg)))))
      (when (zerop (search "echo!" cmd))
        (lispcord:reply msg (subseq cmd 6))))))

(start-bot echo-bot)
