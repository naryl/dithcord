[![Build Status](https://travis-ci.com/naryl/dithcord.svg?branch=master)](https://travis-ci.com/naryl/dithcord)

FAQ
===

What's this?
------------

Dithcord is a library for making modular Discord bots. It's mainly developed
for [dithcord-tui](https://github.com/naryl/dithcord-tui) and dithcord-gui but
it's absolutely usable for any kind of bot.

How is Dithcord (the library) different fron Lispcord?
------------------------------------------------------

The main difference is that [Lispcord](https://github.com/lispcord/lispcord)
supports running several monolithic bots in the same lisp-system while Dithcord
supports running a single modular bot. If either suits you then you should
probably pick Lispcord to avoid an extra layer you don't need. Dithcord is not
a complete abstraction and you'll have to use Lispcord functions anyway.

Also, Lispcord is more imperative while Dithcord is more declarative with all
the `define-stuff` macros.

What's with the lisp?
---------------------

Well, both Dithcord and Lispcord have lots of it.

Dithcord (the library)
======================

Since the current code is in such a state that it probably shouldn't have been
published yet this section contains very little.

Example
-------

More are in the examples directory.

```lisp
(in-package dithcord-user)

;; Define a bot named ECHO-BOT with one module ECHO
;; Modules are not loaded until the bot is started
(define-bot echo-bot (echo)
  ;; Parameters are evaluated. You can load it from a config file e.g.
  :token "")

;; Define a module ECHO with no dependencies.
;; Lispcord is always available without any modules.
(define-module echo ())

;; Define a handler for event :ON-MODULE-LOAD handled by the module ECHO.
;; Dithcord has some special events and the rest (like :on-message-create) are the same as Lispcord's
(define-handler echo :on-module-load ()
  (v:info :echo-bot "ECHO loaded!"))

;; Define another handler for :ON-MESSAGE-CREATE
(define-handler echo :on-message-create (msg)
  ;; This code is from Lispcord's example
  (unless (lc:botp (lc:author msg))
    (let ((cmd (string-trim " " (lispcord:remove-mention (lispcord:me) (lc:content msg)))))
      (when (eql 0 (search "echo!" cmd))
        (lispcord:reply msg (subseq cmd 6))))))

;; Start the bot
(start-bot 'echo-bot)
```

Special events
----------------

`:on-module-load` - Called when the module is loaded into the bot after the
module's dependencies are loaded. The connection may not exist. Use `:on-ready`
to do stuff when re/connected.

`:on-module-unload` - Called when the module is unloaded from a bot, either
because the bot is redefined without this module or because the bot is being
stopped.
