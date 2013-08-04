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
    (loop with arr = (make-array (list height width))
          for i from 0
          for line in s
          do (loop for j from 0
                   for c across line
                   do (setf (aref arr i j) (funcall proc-sym c)))
          finally (return arr))))

(defun create-world-from-file (file player)
  (let* ((a (parse-map-from-file file))
         (max-x (array-dimension a 1))
         (max-y (array-dimension a 0))
         (entity-positions (make-hash-table)))
    (dotimes (x max-x)
      (dotimes (y max-y)
        (let ((c (aref a y x)))
          (labels ((save-position (c)
                     (when (typep c 'entity)
                       (setf (gethash c entity-positions) (cons x y))))
                   (proc (c)
                     (if (eq c :player)
                         (progn (if (gethash player entity-positions)
                                    (error "Player position defined twice.")
                                    (save-position player))
                                player)
                         (progn (save-position c)
                                c))))
            (setf (aref a y x)
                  (if (listp c)
                      (mapcar #'proc c)
                      (list (proc c))))))))
    (unless (gethash player entity-positions)
      (error "No player position defined in map."))
    (make-world :cells a
                :entity-positions entity-positions
                :player player)))
