(in-package #:dikurogue)

(defclass entity ()
  ((pos
    :initarg :pos
    :initform (error "Must supply a position.")
    :reader entity-pos)
   (symbol
    :initarg :symbol
    :initform (error "Objects must have a symbol")
    :reader entity-symbol)))

(defun entity-x (ent)
  (car (slot-value ent 'pos)))

(defun entity-y (ent)
  (cdr (slot-value ent 'pos)))

(defgeneric draw (ent)
  (:documentation "'Draw' the entity by creating the corresponding glyph."))

(defmethod draw ((ent entity))
  (make-instance 'glyph
                 :x (entity-x ent)
                 :y (entity-y ent)
                 :char (entity-symbol ent)))
