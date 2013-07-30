;;;; dikurogue.asd

(asdf:defsystem #:dikurogue
  :serial t
  :description "DIKURogue is a roguelike."
  :author "Philip Munksgaard <pmunskgaard@gmail.com>"
  :license "mit"
  :depends-on (#:lispbuilder-sdl)
  :components ((:file "package")
               (:file "src/main")
               (:file "src/sdl")))
