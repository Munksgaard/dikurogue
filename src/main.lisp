;;;; dikurogue.lisp

(in-package #:dikurogue)

;;; "dikurogue" goes here. Hacks and glory await!

(defun generate-screen (state)
  (let* ((player-pos (cdr (assoc :player-pos state)))
         (x (car player-pos))
         (y (cdr player-pos)))
    (acons :screen
           (list (make-instance 'glyph
                                :x x
                                :y y
                                :char #\@
                                :fg-color sdl:*black*
                                :bg-color sdl:*white*))
           state)))

(defun move-player (state dir)
  (let* ((player-pos (cdr (assoc :player-pos state)))
         (x (car player-pos))
         (y (cdr player-pos))
         (max-x (cdr (assoc :max-x state)))
         (max-y (cdr (assoc :max-y state))))
    (cond
      ((eq dir :left) (acons :player-pos (cons (max 0 (1- x)) y) state))
      ((eq dir :down) (acons :player-pos (cons x (min max-y (1+ y))) state))
      ((eq dir :up) (acons :player-pos (cons x (max 0 (1- y))) state))
      ((eq dir :right) (acons :player-pos (cons (min max-x (1+ x)) y) state)))))

(defun handle-key (state key)
  (case key
    (:sdl-key-q ())
    (:sdl-key-h (generate-screen (move-player state :left)))
    (:sdl-key-j (generate-screen (move-player state :down)))
    (:sdl-key-k (generate-screen (move-player state :up)))
    (:sdl-key-l (generate-screen (move-player state :right)))))

(defun main (&key (width 80) (height 24))
  (let* ((max-x (1- width))
         (max-y (1- height))
         (state (generate-screen
                 (list (cons :player-pos '(0 . 0))
                       (cons :max-x  max-x)
                       (cons :max-y max-y)
                       (cons :walls '((5 . 5)))))))
    (sdl-loop state #'handle-key)))
