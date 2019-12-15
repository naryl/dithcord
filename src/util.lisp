
(in-package dithcord)

(defun set-stable-difference (list1 list2 &key key)
  (remove-if (lambda (item)
               (member item list2))
             list1
             :key key))
