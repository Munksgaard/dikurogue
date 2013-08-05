(in-package #:dikurogue)

(defclass entity ()
  ((symbol
    :initarg :symbol
    :initform (error "Objects must have a symbol")
    :reader entity-symbol)))

(defmethod draw-object ((ent entity))
  (list :char (entity-symbol ent)))

(defvar *wall* (make-instance 'entity :symbol #\#))
