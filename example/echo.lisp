
(in-package dithcord-user)

;; Modules are not loaded until the bot is started
(dc:define-bot echo-bot (echo)
  ;; Parameters are evaluated. You can load it from a config file e.g.
  :token "DUMMY"
  :command-prefix "!")

(dc:define-module echo (dc:commands))

;; Dithcord has some special events and the rest (like :on-message-create) are the same as Lispcord's
(define-handler echo :on-module-load ()
  (v:info :echo-bot "ECHO loaded!"))

(dc:define-command echo :echo (msg &rest args)
  (dc:reply msg (apply #'concatenate 'string args)))

(dc:start-bot 'echo-bot)
