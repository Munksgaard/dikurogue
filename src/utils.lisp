(in-package #:dikurogue)

(defun dissoc (key xs)
  (remove-if (lambda (x) (equal (car x) key)) xs))

(defun pos-offset (pos &key (dx 0) (dy 0) world)
  "Calculates the a new position given a position and an offset.

A position is a pair of an x-value and a y-value.

If given a world it ensures that the new position is within the bounds of the
level."
  (let ((old-x (car pos))
        (old-y (cdr pos)))
    (cons (min (world-max-x world) (max 0 (+ old-x dx)))
          (min (world-max-y world) (max 0 (+ old-y dy))))))

(defun pos-diff (pos-1 pos-2)
  (cons (- (car pos-2) (car pos-1))
        (- (cdr pos-2) (cdr pos-1))))

(defun pos-offset-to-dir (pos)
  (if (< (abs (car pos)) (abs (cdr pos)))
      (if (< (cdr pos) 0)
          :n
          :s)
      (if (< (car pos) 0)
          :w
          :e)))