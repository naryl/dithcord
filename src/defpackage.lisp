
(defpackage dithcord
  (:use :common-lisp)
  (:export #:define-bot #:start-bot #:stop-bot
           #:define-module #:module-slot
           #:define-handler

           ;; accessors
           #:token

           ;; Selfbots
           #:get-user-token #:invalid-login-data #:message
           ))

(defpackage dithcord.handlers)

(defpackage dithcord-user
  ;; Use lispcord: and lc: to access Lispcord
  (:use :common-lisp :dithcord))
