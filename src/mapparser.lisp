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
               for object = (handler-case (read-from-string (subseq (first s) 2))
                              (t () (error "Invalid symbol line: ~S" (first s))))
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
    (loop with arr = (make-array (list height width)
                                 :initial-element (funcall proc-sym #\Space))
          for i from 0
          for line in s
          do (loop for j from 0
                   for c across line
                   do (setf (aref arr i j) (funcall proc-sym c)))
          finally (return arr))))

(defun create-map-from-file (file)
  (let* ((a (parse-map-from-file file))
         (max-x (array-dimension a 1))
         (max-y (array-dimension a 0))
         player-pos
         walls)
    (dotimes (i max-y)
      (dotimes (j max-x)
        (case (aref a i j)
          (:void)
          (:floor)
          (:wall (push (cons j i) walls))
          (:player (if player-pos
                       (error "Player defined multiple times."))
                   (setf player-pos (cons j i)))
          ;; Add everything else as walls until we can handle other
          ;; things.
          (t (push (cons j i) walls)))))
    (unless player-pos
      (error "No player defined."))
    (list (cons :player-pos player-pos)
          (cons :max-x max-x)
          (cons :max-y max-y)
          (cons :walls walls))))
