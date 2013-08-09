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
                           :y (1+ y)
                           (draw c))
                    l))
            l))
    (draw-string (format nil "~{~a~^ ~}" (reverse (state-messages state)))
                 0 0 state)
    (generate-hud state)))

(defun process-ticks (state)
  (dolist (e (world-active-entities (state-world state)))
    (tick e state)))

(defun handle-input (state key)
  (setf (state-messages state) nil)
  (labels ((next ()
             (process-ticks state)
             (generate-screen state))
           (move (dir)
             (move-player dir state)
             (next)))
    (case key
      (:sdl-key-q ())
      ((:sdl-key-h :sdl-key-a :sdl-key-left)
       (move :w))
      ((:sdl-key-j :sdl-key-s :sdl-key-down)
       (move :s))
      ((:sdl-key-k :sdl-key-w :sdl-key-up)
       (move :n))
      ((:sdl-key-l :sdl-key-d :sdl-key-right)
       (move :e))
      (:sdl-key-period
       (next))
      (t state))))

(defun main (&key (name "Karl Koder") (max-hp 10) map (width 80) (height 24))
  (let ((player (make-instance 'player :name name
                               :max-hp max-hp)))
    (sdl-loop (generate-screen (make-state
                                :world
                                (if map
                                    (create-world-from-file map player)
                                    (make-default-world player))
                                :window-width width
                                :window-height height))
              #'handle-input
              :width width
              :height height)))

(defun make-default-world (player)
  (let ((w (make-world :cells (make-array
                               (list 3 3)
                               :initial-contents `((nil nil nil)
                                                   (nil nil nil)
                                                   (nil nil nil))))))
    (add-entity w player '(1 . 1))
    w))
