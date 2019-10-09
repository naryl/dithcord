
(defpackage dithcord
  (:use :common-lisp)
  (:export #:define-bot #:start-bot #:stop-bot
           #:define-module #:module-slot
           #:define-handler #:define-function
           ))

(defpackage dithcord.handlers)

(defpackage dithcord-user
  ;; Lispcord has a nickname "lc". Use it instead of :use'ing the package.
  (:use :common-lisp :dithcord))
