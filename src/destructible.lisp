(in-package #:dikurogue)

(defclass destructible (entity)
  ((hp
    :initarg :hp)
   (max-hp
    :initarg :max-hp
    :initform (error "Must supply max hitpoints"))))

(defmethod initialize-instance :after ((obj destructible) &key)
  (unless (slot-boundp obj 'hp)
    (setf (slot-value obj 'hp) (slot-value obj 'max-hp))))

(defgeneric take-damage (obj dmg state))

(defmethod take-damage ((obj destructible) dmg state)
  (let ((hp (slot-value obj 'hp)))
    (setf (slot-value obj 'hp) (- hp dmg))
    (when (<= (slot-value obj 'hp) 0)
      (destroy obj state))))

(defgeneric destroy (obj state))

(defmethod destroy ((obj destructible) state)
  (setf (cdr (assoc :entities state))
        (remove obj (cdr (assoc :entities state)))))
