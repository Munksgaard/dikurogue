(in-package #:dikurogue)

(defclass npc () ())

(defgeneric tick (npc state))

(defmethod tick ((npc npc) state)
  state)

(defclass rat (npc destructible attacker movable entity)
  ((max-hp :initform 5)
   (symbol :initform #\r)))

(defmethod tick ((x rat) state)
  (move x (pos-offset-to-dir
           (pos-diff (entity-pos x)
                     (entity-pos (cdr (assoc :player state)))))
        state))
