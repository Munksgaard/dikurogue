(defvar *first-names*)
(setf *first-names* '("Jyrki" "Pawel" "Knud"))

(defvar *surnames*)
(setf *surnames* '("den Onde" "den Frygtelige" "den Grusomme"))

(defun get-random-item (from)
  (nth (random (length from)) from))

(defun generate-random-name ()
  (concatenate 'string
               (get-random-item *first-names*)
               " "
               (get-random-item *surnames*)))
