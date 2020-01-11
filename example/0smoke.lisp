
(in-package dithcord-user)

(define-bot echo-bot (echo)
  :token "")

(define-module echo ())

(define-handler echo :on-module-load ()
  (v:info :echo-bot "ECHO loaded!"))

;; Yep, this will not connect without a token, but we consider it fine
;; as long as it doesn't crash
(start-bot 'echo-bot)
(sleep 2)
(stop-bot)
