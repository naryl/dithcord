
(in-package dithcord)

(defun set-stable-difference (list1 list2 &key key)
  (remove-if (lambda (item)
               (member item list2))
             list1
             :key key))

(defmacro mapf (list (&rest args) &body body)
  `(map 'list (lambda ,args ,@body) ,list))

(defun filter-class (seq class)
  (remove-if-not (lambda (obj)
                  (typep obj class))
                 (coerce seq 'list)))
