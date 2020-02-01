
(in-package dithcord.modules)

#.dithcord::declaim-optimize

(dc:define-module state-tracker ())

(dc:define-handler state-tracker :on-ready (payload)
  (setf *guild-ids* (map 'list #'lc:id (lc:guilds payload))))

(dc:define-handler state-tracker :on-guild-create (guild)
  (pushnew (lc:id guild) *guild-ids*))

;;;; Guilds

(defvar *guild-ids* (list))

(defun guilds ()
  "All guilds known to this bot"
  (remove-if-not 'lc:availablep
                 (dc:mapf *guild-ids* (id)
                   (lispcord:from-id id :guild))))

;;;; Channels

(defun channels (obj &key (type 'lc:channel) (only-viewable t))
  "As lc:channels but can also filter by channel type"
  (when (lc:availablep obj)
    (let ((channels (if type
                        (dithcord::filter-class (lc:channels obj) type)
                        (lc:channels obj))))
      (if only-viewable
          (remove-if-not (lambda (c)
                           (lc:has-permission (dc:me) :view-channel c))
                         channels)
          channels))))

