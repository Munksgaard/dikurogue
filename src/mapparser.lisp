;;;; mapparser.lisp

(in-package #:dikurogue)

(defun read-lines-from-file (file)
  (with-open-file (s file :direction :input)
    (loop for line = (read-line s nil)
          while line collect line)))

(defun parse-map (s)
  (let ((rules
         (loop until (or (null s)
                         (string= (first s) ""))
               for char = (aref (first s) 0)
               for object = (handler-case (let ((*package* #.*package*))
                                            (eval (read-from-string (subseq (first s) 2))))
                              (t (err) (error "Invalid symbol line '~A': ~A" (first s) err)))
               do (pop s)
               collecting (cons char object))))
    (unless (null s)
      (pop s))
    (parse-layout s (lambda (c)
                      (cdr (or (assoc c rules)
                               (error "Unknown character '~A'" c)))))))

(defun parse-map-from-file (f)
  (parse-map (read-lines-from-file f)))

(defun parse-layout (s proc-sym)
  (let ((height (length s))
        (width (apply #'max (mapcar #'length s))))
    (loop with arr = (make-array (list height width))
          for i from 0
          for line in s
          do (loop for j from 0
                   for c across line
                   do (setf (aref arr i j) (funcall proc-sym c)))
          finally (return arr))))

(defvar *player*
  "Bound to the player object when reading a map.")

(defun create-world-from-file (file player)
  (let* ((*player* player)
         (map (parse-map-from-file file))
         (max-x (array-dimension map 1))
         (max-y (array-dimension map 0))
         (world (make-world
                 :cells (make-array (list max-y max-x)
                                    :initial-element '()))))
    (dotimes (x max-x)
      (dotimes (y max-y)
        (let ((c (aref map y x)))
          (labels ((proc (e)
                     (add-entity world e (cons x y))))
            (if (listp c)
                (mapcar #'proc c)
                (proc c))))))
    (unless (world-player world)
      (error "No player position defined in map."))
    world))
