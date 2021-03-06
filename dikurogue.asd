;;;; dikurogue.asd

(asdf:defsystem #:dikurogue
  :serial t
  :description "DIKURogue is a roguelike."
  :author "Philip Munksgaard <pmunskgaard@gmail.com>"
  :license "mit"
  :depends-on (#:lispbuilder-sdl)
  :components ((:file "package")
               (:file "src/entity")
               (:file "src/destructible")
               (:file "src/attacker")
               (:file "src/movable")
               (:file "src/player")
               (:file "src/npc")
               (:file "src/sdl")
               (:file "src/mapparser")
               (:file "src/world")
               (:file "src/state")
               (:file "src/utils")
               (:file "src/ui")
               (:file "src/main")))
