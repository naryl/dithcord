
(in-package cl-user)

(defpackage dithcord.commands
  (:use :cl)
  (:export #:commands
           #:define-command
           #:set-command-prefix
           ))

(uiop:define-package dithcord
  (:use :cl :anaphora
        :dithcord.commands)
  (:reexport :dithcord.commands)
  (:export #:define-bot #:start-bot #:stop-bot
           #:define-module #:module-slot
           #:define-handler

           ;; accessors
           #:token

           ;; Selfbots
           #:get-user-token #:invalid-login-data #:message
           ))

;; Used for Lispcord handlers
(defpackage dithcord.handlers)

(defpackage dithcord-user
  ;; Use lispcord: and lc: to access Lispcord
  (:use :cl :dithcord))
