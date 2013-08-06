(in-package #:dikurogue)

(defclass movable (entity has-position-mixin) ())

(defgeneric move (ent dir world)
    (:documentation "The function that implements the move."))

(defmethod move ((ent movable) dir world)
  (let* ((pos (entity-position ent))
         (new-pos (case dir
                    (:n (pos-offset pos :dy -1))
                    (:e (pos-offset pos :dx 1))
                    (:s (pos-offset pos :dy 1))
                    (:w (pos-offset pos :dx -1)))))
    (when (within-world-bounds world new-pos)
      (let* ((there (entities-at world new-pos))
             (enemy (find-if (lambda (obj) (typep obj 'attacker)) there)))
        (cond
          (enemy
           (attack ent enemy world))
          ((null there)
           (move-entity world ent new-pos)))))))
