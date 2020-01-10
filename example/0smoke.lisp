
(in-package dithcord-user)

(define-bot echo-bot (echo)
  :token "NTYwNTk1MjYzNjYwNjIxODY0.XhjKnQ.HWJQPIKZ7FteOUftaBmvlK9VoSw")

(define-module echo ())

(define-handler echo :on-module-load ()
  (v:info :echo-bot "ECHO loaded!"))

(start-bot 'echo-bot)
(sleep 2)
(stop-bot)
