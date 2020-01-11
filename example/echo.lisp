
(in-package dithcord-user)

;; Modules are not loaded until the bot is started
(define-bot echo-bot (echo)
  ;; Parameters are evaluated. You can load it from a config file e.g.
  :token "DUMMY"
  :command-prefix "!")

(define-module echo (commands))

;; Dithcord has some special events and the rest (like :on-message-create) are the same as Lispcord's
(define-handler echo :on-module-load ()
  (v:info :echo-bot "ECHO loaded!"))

(define-command echo :echo (msg &rest args)
  (lispcord:reply msg (apply #'concatenate 'string args)))

(start-bot 'echo-bot)
