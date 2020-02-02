
(in-package dithcord.modules)

#.dithcord::declaim-optimize

(dc:defsetting current-guild-id ())
(dc:defsetting current-channel-id (guild-id))

(dc:define-module client (dcm:state-tracker))

(dc:define-handler client :on-ready (payload)
  (declare (ignore payload))
  ;; If we got at least one available guild
  (unless (zerop (length (dcm:guilds)))
    (initialize-guild)))

(dc:define-handler client :on-guild-create (guild)
  (declare (ignore guild))
  ;; Got our first available guild
  (when (= 1 (length (dcm:guilds)))
    (initialize-guild)))

;;; Senders

(defun send-message (text)
  nil)

(defun switch-channel (num)
  (let ((channels (dcm:channels (current-guild) :type 'lc:text-channel)))
    (let ((channel-pos (position (current-channel) channels)))
      ;; Get the new channel in
      (unless channel-pos
        (setf channel-pos -1))
      (incf channel-pos num)
      (setf channel-pos (alexandria:clamp channel-pos 0 (length channels)))
      (setf (current-channel) (nth channel-pos channels)))))

;;; MISC

(defun initialize-guild ()
  (unless (and (current-guild-id) (current-guild))
    (setf (current-guild) (first (dcm:guilds))))
  (when (current-guild)
    (alexandria:when-let ((channels (dcm:channels (current-guild) :type 'lc:text-channel)))
      (unless (and (current-guild-id) (current-channel-id (current-guild-id)) (current-channel))
        (setf (current-channel) (elt channels 0))))))

(defun current-guild ()
  (lc::getcache-id (current-guild-id) :guild))
(defun current-channel ()
  (lc::getcache-id (current-channel-id (current-guild-id)) :channel))

(defun (setf current-guild) (g)
  (setf (current-guild-id) (lc:id g)))
(defun (setf current-channel) (c)
  (let ((gid (current-guild-id)))
    (setf (current-channel-id gid) (lc:id c))))

(defun timestamp-time (timestamp)
  (let* ((time+tz (elt (split-sequence:split-sequence #\T timestamp) 1))
         (time (elt (split-sequence:split-sequence #\. time+tz) 0)))
    time))
