;;;; dikurogue.lisp

(in-package #:dikurogue)

;;; "dikurogue" goes here. Hacks and glory await!

(defun draw-walls (walls)
  (mapcar (lambda (wall-pos)
            (make-instance 'glyph
                           :x (car wall-pos)
                           :y (cdr wall-pos)
                           :char #\#))
          walls))

(defun generate-screen (state)
  (let* ((player (cdr (assoc :player state)))
         (walls (cdr (assoc :walls state)))
         (entities (cdr (assoc :entities state))))
    (acons :screen
           (cons (draw player)
                 (append (draw-walls walls)
                         (mapcar #'draw entities)))
           state)))

(defun sanitize-state (state)
  "Removes duplicate entries in the state list"
  (remove-duplicates state
                     :test (lambda (x y) (equal (car x) (car y)))
                     :from-end t))

(defun handle-input (state key)
  (sanitize-state
   (case key
     (:sdl-key-q ())
     (:sdl-key-h (progn (move-player :w state) (generate-screen state)))
     (:sdl-key-j (progn (move-player :s state) (generate-screen state)))
     (:sdl-key-k (progn (move-player :n state) (generate-screen state)))
     (:sdl-key-l (progn (move-player :e state) (generate-screen state)))
     (t state))))

(defun main (&key (state *default-state*))
  (sdl-loop (generate-screen state) #'handle-input))

(defparameter *default-state*
  (generate-screen
   (list (cons :max-x  79)
         (cons :max-y 23)
         (cons :walls '((5 . 5)))
         (cons :player (make-instance 'player :name "Philip" :pos '(0 . 0) :max-hp 10))
         (cons :entities (list (make-instance 'destructible
                                              :symbol #\r
                                              :pos '(5 . 2)
                                              :hp 5
                                              :max-hp 5)
                               (make-instance 'destructible
                                              :symbol #\r
                                              :pos '(2 . 2)
                                              :hp 5
                                              :max-hp 5)))
         (cons :time-modifier #'quote))))
