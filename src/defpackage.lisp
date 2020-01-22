
(in-package cl-user)

(defpackage dithcord.modules
  (:use :cl)
  (:export #:commands
           #:define-command
           #:set-command-prefix
           ))

(uiop:define-package dithcord
  (:use :cl :anaphora
        :dithcord.modules)
  (:reexport :dithcord.modules)
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
