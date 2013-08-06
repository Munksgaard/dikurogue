(in-package #:dikurogue)

(defun draw-string (str x y state)
  (dotimes (i (length str))
    (push (make-instance 'glyph
                         :x (+ x i)
                         :y y
                         :char (aref str i))
          (state-screen state)))
  state)

(defun generate-hud (state)
  (let ((player (world-player (state-world state)))
        (max-y (1- (state-window-height state))))
    (draw-string
     (format nil "Name: ~A, HP: ~d/~d"
             (player-name player)
             (slot-value player 'hp)
             (slot-value player 'max-hp))
     0 max-y state)))
