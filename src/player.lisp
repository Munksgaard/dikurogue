(in-package #:dikurogue)

(defclass player (movable attacker destructible)
  ((name
    :initarg :name
    :initform (error "Player must have a name")
    :reader player-name)
   (symbol :initform #\@)
   (inventory
    :initarg :inventory
    :initform ()
    :reader player-inventory)))

(defun move-player (dir state)
  (let ((player (cdr (assoc :player state))))
    (move player dir state)))

(defmethod destroy ((obj destructible) state)
  (sdl:push-quit-event)
  (format t "Game Over.~%"))
