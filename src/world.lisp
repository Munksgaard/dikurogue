;;;; world.lisp

(in-package #:dikurogue)

(defstruct world
  cells
  entity-positions
  player)

(defun world-max-x (world)
  (array-dimension (world-cells world) 1))

(defun world-max-y (world)
  (array-dimension (world-cells world) 0))

(defun within-world-bounds (world pos)
  (and (> (world-max-x world) (car pos) -1)
       (> (world-max-y world) (cdr pos) -1)))

(defun entities-at (world pos)
  (aref (world-cells world) (cdr pos) (car pos)))

(defmacro do-world-cells ((c x y world) &body body)
  (let ((w (gensym)))
   `(let ((,w ,world))
      (dotimes (,x (world-max-x ,w))
        (dotimes (,y (world-max-y ,w))
          (let ((,c (aref (world-cells ,w) ,y ,x)))
            ,@body))))))

(defun move-entity (world entity new-pos)
  (destructuring-bind (new-x . new-y) new-pos
    (destructuring-bind (old-x . old-y)
        (gethash entity (world-entity-positions world))
      (setf (gethash entity (world-entity-positions world)) new-pos)
      (setf (aref (world-cells world) old-y old-x)
            (remove entity (aref (world-cells world) old-y old-x)))
      (push entity (aref (world-cells world) new-y new-x)))))

(defun entity-pos (world entity)
  (or (gethash entity (world-entity-positions world))
      (error "Entity ~A does not have a registered position." entity)))

(defun is-occupied (world pos)
  (not (null (entities-at world pos))))
