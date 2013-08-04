(in-package #:dikurogue)

(defun dissoc (key xs)
  (remove-if (lambda (x) (equal (car x) key)) xs))

(defun is-occupied (pos state)
  (let ((entities (cdr (assoc :entities state))))
    (find pos entities :test (lambda (x y) (and (equal x (entity-pos y))
                                                (typep y 'entity))))))

(defun pos-offset (pos &key (dx 0) (dy 0) state)
  "Calculates the a new position given a position and an offset.

A position is a pair of an x-value and a y-value.

If given a state it ensures that the new position is within the bounds of the
level."
  (let ((old-x (car pos))
        (old-y (cdr pos)))
    (if (null state)
        (cons (+ old-x dx) (+ old-y dy))
        (cons (min (cdr (assoc :max-x state)) (max 0 (+ old-x dx)))
              (min (cdr (assoc :max-y state)) (max 0 (+ old-y dy)))))))

(defun can-move (pos state)
  (let ((walls (cdr (assoc :walls state))))
    (not (some (lambda (wall) (equal wall pos)) walls))))
