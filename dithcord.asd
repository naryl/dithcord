
(defsystem dithcord
    :depends-on (:alexandria :lispcord :verbose)
    :pathname "src/"
    :serial t
    :components ((:file "defpackage")
                 (:file "dev")
                 (:file "bot")
                 (:file "handlers")
                 (:file "module")
                 ))
