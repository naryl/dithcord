
(in-package dithcord-user)

(setf (v:repl-level) :info)

;; Modules are not loaded until the bot is started
(define-bot selfbot (echo)
  ;; Parameters are evaluated. You can load it from a config file e.g.
  :auth ("USERNAME" "PASSWORD")
  :selfbot t)

(define-module echo ())

;; Dithcord has some special events and the rest (like :on-message-create) are the same as Lispcord's
(define-handler echo :on-module-load ()
  (v:info :echo-bot "ECHO loaded!"))

(define-handler echo :on-message-create (msg)
  (unless (lc:botp (lc:author msg))
    (let ((cmd (string-trim " " (lispcord:remove-mention (lispcord:me) (lc:content msg)))))
      (when (eql 0 (search "echo!" cmd))
        (lispcord:reply msg (subseq cmd 6))))))

(start-bot 'selfbot)
