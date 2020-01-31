
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

(defun channels (obj &key (type 'lc:channel) non-viewable)
  "As lc:channels but can also filter by channel type"
  (let ((channels (if type
                      (dithcord::filter-class (lc:channels obj) type)
                      (lc:channels obj))))
    (if (not non-viewable)
        (remove-if-not (lambda (c)
                         (lc:has-permission (dc:me) :view-channel c))
                       channels)
        channels)))

