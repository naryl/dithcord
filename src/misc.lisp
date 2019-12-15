
(in-package dithcord)

(define-condition invalid-login-data (error)
  ((email :initarg :email :reader email)
   (password :initarg :password :reader password)
   (message :initarg :message :reader message))
  (:report (lambda (c s) (format s "Error logging in: ~A" (message c))))
  (:documentation "Error obtaining user token from Discord API"))

(defun get-user-token (email password)
  (let ((payload (format nil "{\"email\":\"~A\",\"password\":\"~A\",\"undelete\":false,\"captcha_key\":null,\"login_source\":null,\"gift_code_sku_id\":null}"
                         email password)))
    (multiple-value-bind (response code)
        (drakma:http-request "https://discordapp.com/api/v6/auth/login"
                             :method :post
                             :content-type "application/json"
                             :content payload)
      (let ((response (flexi-streams:octets-to-string response)))
        (if (= code 200)
            (getf (jonathan:parse response) :|token|)
            (error 'invalid-login-data
                   :email email
                   :password password
                   :message response))))))
