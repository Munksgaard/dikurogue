(in-package #:dikurogue)

(defclass glyph ()
  ((x
    :initarg :x
    :initform (error "Must supply an x-coordinate.")
    :reader glyph-x)
   (y
    :initarg :y
    :initform (error "Must supply a y-coordinate.")
    :reader glyph-y)
   (char
    :initarg :char
    :initform #\
    :reader glyph-char)
   (fg-color
    :initarg :fg-color
    :initform sdl:*white*
    :reader glyph-fg-color)
   (bg-color
    :initarg :bg-color
    :initform sdl:*black*
    :reader glyph-bg-color)))

(defun sdl-render (screen char-width char-height)
  (sdl:clear-display sdl:*black*)
  (dolist (glyph screen)
    (sdl:draw-string-shaded-* (string (glyph-char glyph))
                              (* (glyph-x glyph) char-width)
                              (* (glyph-y glyph) char-height)
                              (glyph-fg-color glyph)
                              (glyph-bg-color glyph)))
  (sdl:update-display))

(defun sdl-loop (initial-state key-handler &key (width 80)
                                             (height 24)
                                             (font-in sdl:*FONT-9X15*))
  (sdl:with-init ()
    (let* ((char-width (sdl:char-width font-in))
          (char-height (sdl:char-height font-in))
          (window-width (* char-width width))
          (window-height (* char-height height))
          (font (sdl:initialise-font font-in))
          (state initial-state)
          (initial-screen (state-screen state)))
      (sdl:with-default-font (font)
        (sdl:window window-width window-height)
        (sdl:enable-key-repeat 500 50)
        (if (null initial-screen)
            (error "No screen in initial state")
            (sdl-render initial-screen char-width char-height))
        (sdl:with-events ()
          (:quit-event () t)
          (:video-expose-event () (sdl:update-display))
          (:key-down-event
           (:key key)
           (let ((new-state (funcall key-handler state key)))
             (if (null new-state)
                 (sdl:push-quit-event)
                 (let ((screen (state-screen new-state)))
                   (cond
                     ((null screen) (error "No screen in return value"))
                     (t (setf state new-state)
                        (sdl-render screen char-width char-height))))))))))))
