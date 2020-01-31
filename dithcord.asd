
(defsystem dithcord
  :depends-on (:alexandria :anaphora :drakma :flexi-streams
               :verbose :jonathan
               :lispcord)
  :pathname "src/"
  :serial t
  :components ((:file "defpackage")
               (:file "misc")
               (:file "util")
               (:file "dev")
               (:file "bot")
               (:file "handlers")
               (:file "module")
               (:module modules
                :serial t
                :components ((:file "commands")
                             (:file "state-tracker")))))
