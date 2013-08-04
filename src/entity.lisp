(in-package #:dikurogue)

(defclass entity ()
  ((symbol
    :initarg :symbol
    :initform (error "Objects must have a symbol")
    :reader entity-symbol)))

(defun entity-x (ent)
  (car (slot-value ent 'pos)))

(defun entity-y (ent)
  (cdr (slot-value ent 'pos)))

(defmethod draw-object ((ent entity))
  (list :char (entity-symbol ent)))
