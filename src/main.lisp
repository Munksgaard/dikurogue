;;;; dikurogue.lisp

(in-package #:dikurogue)

;;; "dikurogue" goes here. Hacks and glory await!


(defgeneric draw-object (object))

(defmethod draw-object ((object symbol))
  (case object
    (:void '(:char #\Space))
    (:wall '(:char #\#))
    (:player '(:char #\#))
    (t '(:char #\#))))

(defun generate-screen (state)
  (flet ((draw (l)
           (if (null l)
               '(:char #\Space)
               (draw-object (first l)))))
    (setf (state-screen state)
          (let (l)
            (do-world-cells (c x y (state-world state))
              (push (apply #'make-instance 'glyph
                           :x x
                           :y y
                           (draw c))
                    l))
            l))
    state))

(defun process-ticks (world)
  (dolist (e (world-active-entities  world))
    (tick e world)))

(defun handle-input (state key)
  (let ((world (state-world state)))
    (case key
      (:sdl-key-q ())
      (:sdl-key-h (progn (move-player :w world)
                         (process-ticks world)
                         (generate-screen state)))
      (:sdl-key-j (progn (move-player :s world)
                         (process-ticks world)
                         (generate-screen state)))
      (:sdl-key-k (progn (move-player :n world)
                         (process-ticks world)
                         (generate-screen state)))
      (:sdl-key-l (progn (move-player :e world)
                         (process-ticks world)
                         (generate-screen state)))
      (:sdl-key-period (progn (process-ticks world)
                              (generate-screen world)))
      (t state))))

(defun main (&key (name "Karl Koder") (max-hp 10) map)
  (let ((player (make-instance 'player :name name
                               :max-hp max-hp)))
    (sdl-loop (generate-screen (make-state
                                :world
                                (if map
                                    (create-world-from-file map player)
                                    (make-default-world player))))
              #'handle-input)))

(defun make-default-world (player)
  (let ((w (make-world :cells (make-array
                               (list 3 3)
                               :initial-contents `((nil nil nil)
                                                   (nil nil nil)
                                                   (nil nil nil))))))
    (add-entity w player '(1 . 1))
    w))
