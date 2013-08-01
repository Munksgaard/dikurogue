# Getting Started

## Introduction

This is a short guide to setting up a work environment for
DIKURogue. I assume you are using Emacs and Linux, but this guide also
includes a description of the project files, and a suggested workflow
that might also apply to users of other editors and operating systems.

## Required Software

 - SBCL. Any newer version should do, 1.1.0 and upwards
 - Emacs. I'm using version 24, but 23 should work as well.
 - Git. Any newer version should do.

All three should be readily available in your package manager.

## Setting Up

### Git

If you haven't already, you should set up your username and email by
running the following commands in your terminal:

    $ git config --global user.name "Your Name"
    $ git config --global user.email your@email.address

Now, clone the dikurogue repository and the lispbuilder repository
from github:

    $ git clone git@github.com:Munksgaard/dikurogue
    $ git clone git@github.com:Munksgaard/lispbuilder

### SBCL

First, we need to install Quicklisp, which is a library manager for
Common Lisp. More info here: http://www.quicklisp.org/beta/

    $ curl -O http://beta.quicklisp.org/quicklisp.lisp
    $ sbcl --load quicklisp.lisp
    * (quicklisp-quickstart:install)
    * (ql:add-to-init-file)
    * (quit)
    $

Notice that in lines 3-5, we're evaluating function calls in SBCL, and
exiting again on line 5.

Next step is to set up the quicklisp repository tree so that we're
sure we can always find our code. We do that by creating a file in
~/.config/common-lisp/source-registry.conf.d/ called 50-src-tree.conf
with the following contents (assuming that my code directory is in
/home/philip/src/)

    (:tree "/home/philip/src/")

Now, we can open sbcl, load the dikurogue project and run it, by
running the following commands in a terminal (press q
in the window to exit):

    $ sbcl
    * (ql:quickload "dikurogue")
    * (dikurogue:main)
    * (quit)
    $

### Emacs

First we need to use quicklisp to install SLIME, which is the Emacs
REPL for Common Lisp:

    $ sbcl
    * (ql:quickload "quicklisp-slime-helper")
    * (quit)
    $

Then, open ~/.emacs and add the following:

    (load (expand-file-name "~/quicklisp/slime-helper.el"))
    ;; Replace "sbcl" with the path to your implementation
    (setq inferior-lisp-program "sbcl")

    (setq slime-net-coding-system 'utf-8-unix)

That makes sure that Emacs uses SBCL, that it can find SLIME, and that
it uses UTF8.

Now, you can start emacs, open a Lisp REPL (Read-Eval-Print-Loop) with
M-x slime (that is, hold the alt button while pressing x and write
'slime') and evaluate

    CL-USER> (ql:quickload "dikurogue")
    CL-USER> (dikurogue:main)

to start the dikurogue game.

# Workflow

Always create a new branch before you start working on a new feature!
