
(in-package dithcord-user)

(dc:define-bot echo-bot (echo)
  :token "")

(dc:define-module echo ())

(dc:define-handler echo :on-module-load ()
  (v:info :echo-bot "ECHO loaded!"))

;; Yep, this will not connect without a token, but we consider it fine
;; as long as it doesn't crash
(dc:start-bot 'echo-bot)
(sleep 2)
(dc:stop-bot)
