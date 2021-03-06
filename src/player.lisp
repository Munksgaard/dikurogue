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

(defmethod destroy ((obj player) world)
  (sdl:push-quit-event)
  (format t "Game Over.~%"))

(defun move-player (dir state)
  (move (world-player (state-world state)) dir state))

(defmethod add-entity :around (world (object player) pos)
  (if (null (world-player world))
      (progn (call-next-method)
             (setf (world-player world) object))
      (error "World already has a player.")))

(defmethod remove-entity :after (world (object player))
  (setf (world-player world) nil))

(defmethod print-object ((p player) out)
  (format out "you"))
