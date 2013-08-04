(in-package #:dikurogue)

(defclass movable (entity) ())

(defgeneric move (ent dir world)
    (:documentation "The function that implements the move."))

(defmethod move ((ent movable) dir world)
  (let* ((pos (entity-pos world ent))
         (new-pos (case dir
                    (:n (pos-offset pos :dy -1 :world world))
                    (:e (pos-offset pos :dx 1 :world world))
                    (:s (pos-offset pos :dy 1 :world world))
                    (:w (pos-offset pos :dx -1 :world world)))))
    (when (within-world-bounds world new-pos)
      (let* ((there (entities-at world new-pos))
             (enemy (find-if (lambda (obj) (typep obj 'attacker)) there)))
        (cond
          (enemy
           (attack ent enemy world))
          ((null there)
           (move-entity world ent new-pos)))))))
