(in-package #:dikurogue)

(defun dissoc (key xs)
  (remove-if (lambda (x) (equal (car x) key)) xs))

(defun is-occupied (pos state)
  (let ((entities (cdr (assoc :entities state)))
        (player (cdr (assoc :player state))))
    (if (equal (entity-pos player) pos)
        player
        (find pos entities :test (lambda (x y) (and (equal x (entity-pos y))
                                                    (typep y 'entity)))))))

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
  (let ((walls (cdr (assoc :terrain state))))
    (not (some (lambda (wall) (equal (entity-pos wall) pos)) walls))))

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
