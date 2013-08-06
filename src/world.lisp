;;;; world.lisp

(in-package #:dikurogue)

(defstruct world
  cells
  player
  active-entities)

(defun world-max-x (world)
  (array-dimension (world-cells world) 1))

(defun world-max-y (world)
  (array-dimension (world-cells world) 0))

(defun within-world-bounds (world pos)
  (and (> (world-max-x world) (car pos) -1)
       (> (world-max-y world) (cdr pos) -1)
       (<= 0 (car pos))
       (<= 0 (cdr pos))))

(defun entities-at (world pos)
  (aref (world-cells world) (cdr pos) (car pos)))

(defgeneric add-entity (world entity pos)
  (:documentation "Add something to the world at the given position.")
  (:method (world entity pos)
    (destructuring-bind (x . y) pos
      (push entity (aref (world-cells world) y x)))))

(defgeneric remove-entity (world entity)
  (:documentation "Remove something from the world."))

(defun remove-entity-at (world entity pos)
  (destructuring-bind (x . y) pos
    (setf (aref (world-cells world) y x)
          (remove entity (aref (world-cells world) y x)))))

(defmacro do-world-cells ((c x y world) &body body)
  (let ((w (gensym)))
   `(let ((,w ,world))
      (dotimes (,x (world-max-x ,w))
        (dotimes (,y (world-max-y ,w))
          (let ((,c (aref (world-cells ,w) ,y ,x)))
            ,@body))))))

(defclass has-position-mixin ()
  ((%position :accessor entity-position)))

(defmethod add-entity :after (world (entity has-position-mixin) pos)
  (setf (entity-position entity) pos))

(defmethod remove-entity (world (entity has-position-mixin))
  (remove-entity-at world entity (entity-position entity)))

(defclass is-active-mixin ()
  ())

(defmethod add-entity :after (world (entity is-active-mixin) pos)
  (push entity (world-active-entities world)))

(defmethod remove-entity :after (world (entity is-active-mixin))
  (setf (world-active-entities world)
        (remove entity (world-active-entities world))))

(defun move-entity (world entity new-pos)
  (remove-entity world entity)
  (add-entity world entity new-pos))

(defun is-occupied (world pos)
  (not (null (entities-at world pos))))
