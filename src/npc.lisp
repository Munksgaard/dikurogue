(in-package #:dikurogue)

(defclass npc (movable is-active-mixin) ())

(defgeneric tick (npc state))

(defmethod tick ((npc npc) state)
  state)

(defclass rat (npc destructible attacker movable entity)
  ((max-hp :initform 5)
   (symbol :initform #\r)))

(defmethod tick ((x rat) state)
  (move x (pos-offset-to-dir
           (pos-diff (entity-position x)
                     (entity-position (world-player (state-world state)))))
        state))

(defmethod print-object ((obj rat) out)
  (format out "a rat"))
