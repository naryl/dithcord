
(in-package dithcord.modules)

(dc:define-module state-tracker ())

(dc:define-handler state-tracker :on-ready (payload)
  (setf *guild-ids* (map 'list #'lc:id (lc:guilds payload))))

;;;; Guilds

(defvar *guild-ids* (list))

(defun guilds ()
  "All guilds known to this bot"
  (dc:mapf *guild-ids* (g)
    (lispcord:from-id g :guild)))

;;;; Channels

(defun channels (obj &optional (type 'lc:channel))
  "As lc:channels but can also filter by channel type"
  (dithcord::filter-class (lc:channels obj) type))

