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

(defmethod destroy ((obj destructible) state)
  (sdl:push-quit-event)
  (format t "Game Over.~%"))

(defun move-player (dir world)
  (move (world-player world) dir world))
