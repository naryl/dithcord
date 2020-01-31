
(in-package cl-user)

(defpackage dithcord.modules
  (:use :cl)
  (:export #:commands
           #:define-command
           #:set-command-prefix

           #:state-tracker
           #:guilds
           #:channels
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

           #:mapf
           ))

(uiop:define-package dithcord.pub
    (:nicknames :dc)
  (:use :cl :lispcord :dithcord :dithcord.modules)
  (:reexport :lispcord :dithcord :dithcord.modules))

;; Used for Lispcord handlers
(defpackage dithcord.handlers)
