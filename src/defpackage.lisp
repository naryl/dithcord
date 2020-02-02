
(in-package cl-user)

(defpackage dithcord.modules
  (:use :cl)
  (:nicknames #:dcm)
  (:export #:commands
           #:define-command
           #:set-command-prefix

           #:state-tracker
           #:guilds
           #:channels

           #:client
           #:send-message
           #:switch-channel
           #:initialize-guild
           #:current-guild
           #:current-channel
           ))

(uiop:define-package dithcord
  (:use :cl :anaphora)
  (:export #:define-bot #:start-bot #:stop-bot
           #:define-module #:module-slot
           #:define-handler

           ;; accessors
           #:token
           #:selfbot

           ;; Selfbots
           #:get-user-token #:invalid-login-data #:message

           #:mapf
           #:defsetting
           ))

(uiop:define-package dithcord.pub
  (:use :cl :lispcord :dithcord)
  (:nicknames :dc)
  (:reexport :lispcord :dithcord))

;; Used for Lispcord handlers
(defpackage dithcord.handlers)
