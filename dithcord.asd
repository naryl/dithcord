
(defsystem dithcord
  :depends-on (:alexandria
               :verbose
               :lispcord)
  :pathname "src/"
  :serial t
  :components ((:file "defpackage")
               (:file "dev")
               (:file "bot")
               (:file "handlers")
               (:file "module")
               ))
