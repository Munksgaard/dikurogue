(in-package #:dikurogue)

(defclass movable (entity) ())

(defgeneric move (ent dir state)
    (:documentation "The function that implements the move."))

(defmethod move ((ent movable) dir state)
  (let* ((pos (entity-pos ent))
         (new-pos (case dir
                    (:n (pos-offset pos :dy -1 :state state))
                    (:e (pos-offset pos :dx 1 :state state))
                    (:s (pos-offset pos :dy 1 :state state))
                    (:w (pos-offset pos :dx -1 :state state))))
         (enemy (is-occupied new-pos state)))
    (cond
      ((and enemy (typep ent 'attacker))
       (attack ent enemy state))
      ((can-move new-pos state) (setf (slot-value ent 'pos) new-pos)))))
