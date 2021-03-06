(in-package #:dikurogue)

(defclass attacker ()
  ((dmg
    :initarg :dmg
    :initform 1
    :reader attacker-dmg)))

(defgeneric attack (obj enemy state)
  (:documentation "Attack an enemy"))

(defmethod attack ((obj attacker) (enemy destructible) state)
  (take-damage enemy (attacker-dmg obj) (state-world state))
  (push (format nil "~@(~a~) attacked ~a for ~a damage." obj enemy (attacker-dmg obj))
        (state-messages state)))
