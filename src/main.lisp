;;;; dikurogue.lisp

(in-package #:dikurogue)

;;; "dikurogue" goes here. Hacks and glory await!

(defun generate-screen (state)
  (let* ((player-pos (cdr (assoc :player-pos state)))
         (x (car player-pos))
         (y (cdr player-pos)))
    (acons :screen
           (cons (make-instance 'glyph
                                :x x
                                :y y
                                :char #\@
                                :fg-color sdl:*black*
                                :bg-color sdl:*white*)
                 (mapcar (lambda (wall-pos)
                           (make-instance 'glyph
                                          :x (car wall-pos)
                                          :y (car wall-pos)
                                          :char #\#))
                         (cdr (assoc :walls state))))
           state)))

(defun sanitize-state (state)
  "Removes duplicate entries in the state list"
  (remove-duplicates state
                     :test (lambda (x y) (equal (car x) (car y)))
                     :from-end t))

(defun pos-offset (pos  &key (delta-x 0) (delta-y 0) state)
  "Calculates the a new position given a position and an offset.

A position is a pair of an x-value and a y-value.

If given a state it ensures that the new position is within the bounds of the
level."
  (let ((old-x (car pos))
        (old-y (cdr pos)))
    (if (null state)
        (cons (+ old-x delta-x) (+ old-y delta-y))
        (cons (min (cdr (assoc :max-x state)) (max 0 (+ old-x delta-x)))
              (min (cdr (assoc :max-y state)) (max 0 (+ old-y delta-y)))))))

(defun can-move (pos state)
  (let ((walls (cdr (assoc :walls state))))
    (not (some (lambda (wall) (equal wall pos)) walls))))

(defun move-player (state dir)
  (let* ((player-pos (cdr (assoc :player-pos state)))
         (new-pos (cond ((eq dir :left) (pos-offset player-pos :delta-x -1))
                        ((eq dir :right) (pos-offset player-pos :delta-x 1))
                        ((eq dir :up) (pos-offset player-pos :delta-y -1))
                        ((eq dir :down) (pos-offset player-pos :delta-y 1))
                        (t (error "Invalid direction")))))
    (if (can-move new-pos state)
        (acons :player-pos new-pos state)
        state)))

(defun handle-key (state key)
  (sanitize-state
   (case key
     (:sdl-key-q ())
     (:sdl-key-h (generate-screen (move-player state :left)))
     (:sdl-key-j (generate-screen (move-player state :down)))
     (:sdl-key-k (generate-screen (move-player state :up)))
     (:sdl-key-l (generate-screen (move-player state :right)))
     (t state))))

(defun main (&key (width 80) (height 24))
  (let* ((max-x (1- width))
         (max-y (1- height))
         (state (generate-screen
                 (list (cons :player-pos '(0 . 0))
                       (cons :max-x  max-x)
                       (cons :max-y max-y)
                       (cons :walls '((5 . 5)))))))
    (sdl-loop state #'handle-key)))
