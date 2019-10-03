
(defsystem dithcord
    :depends-on (:lispcord :verbose)
    :pathname "src/"
    :serial t
    :components ((:file "defpackage")
                 (:file "dev")
                 (:file "main")))
