(in-package #:dikurogue)

(defclass movable (entity has-position-mixin) ())

(defgeneric move (ent dir state)
    (:documentation "The function that implements the move."))

(defmethod move ((ent movable) dir state)
  (let* ((pos (entity-position ent))
         (new-pos (case dir
                    (:n (pos-offset pos :dy -1))
                    (:e (pos-offset pos :dx 1))
                    (:s (pos-offset pos :dy 1))
                    (:w (pos-offset pos :dx -1))))
         (w (state-world state)))
    (when (within-world-bounds w new-pos)
      (let* ((there (entities-at w new-pos))
             (enemy (find-if (lambda (obj) (typep obj 'attacker)) there)))
        (cond
          (enemy
           (attack ent enemy state))
          ((null there)
           (move-entity w ent new-pos)))))))
