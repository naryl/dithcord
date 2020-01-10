[![Build Status](https://travis-ci.com/naryl/dithcord.svg?branch=master)](https://travis-ci.com/naryl/dithcord)

FAQ
===

What's this?
------------

Dithcord is what you may call a "non-automated bot". It's a bot mainly intended to be controlled manually by a user.

Is it a self-bot?
-----------------

Self-bot is the opposite of what Dithcord is. Self-bot is an automated user account. Dithcord doesn't automate and doesn't use a user account. There's a way to make Dithcord introduce itself as a user account but

1. You'll need my Lispcord fork for that.
2. It's VERY likely to get your account banned.

So it's more like a 3rd-party Discord client?
---------------------------------------------

Kinda, except Discord's Terms of Service explicitly forbid implementing 3rd-party clients, so we legally can't introduce the bot as a user account. The main differences between bot accounts and user accounts are outlined here: (https://discordapp.com/developers/docs/topics/oauth2#bot-vs-user-accounts)

What can it do? (AKA Roadmap)
-----------------------------

It has five components, neither of which is finished right now :o)

* **dithcord** - An opinionated bot framework. Uses [Lispcord](https://github.com/lispcord/lispcord) for the protocol implementation.
* **dithcord-cli** - A command-line interface. Just to get something working ~~and usable~~.
* **dithcord-tui** - An ncurses-based Text User Interface. Think irssi or weechat.
* **dithcord-altha** - A library for sending/receiving audio from Discord using ALSA. Unless it's implemented as a part of Lispcord, in which case we'll just use that one. Why ALSA? It's what I use. PipeWire support will be added as soon as its developers release the Pulse Audio-compatible API, in which case we'll hopefully automatically get Pulse Audio support for free. I'm not interested in implementing PA support specifically but contributions are welcome (when we have ALSA at least).
* A GUI. Not even sure what toolkit to use yet.

In the end it should allow you to manually control a bot account, being able to do as much of what a user account can do as possible with a bot account.

How is Dithcord (the library) different fron Lispcord?
------------------------------------------------------

The main difference is that Lispcord supports running several monolithic bots in the same lisp-system while Dithcord supports running a single modular bot. If either suits you then you should probably pick Lispcord to avoid an extra layer you don't need. Dithcord is not a complete abstraction and you'll have to use Lispcord functions anyway.

Also, Lispcord is more imperative while Dithcord is more declarative with all the define-stuff macros.

What's with the lisp?
---------------------

Well, both Dithcord and Lispcord have lots of it.

Dithcord (the library)
======================

Since the current code is in such a state that it probably shouldn't have been published yet this section contains very little.

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

`:on-module-load` - Called when the module is loaded into the bot after the module's dependencies are loaded. The connection may not exist. Use `:on-ready` to do stuff when re/connected.

`:on-module-unload` - Called when the module is unloaded from a bot, either because the bot is redefined without this module or because the bot is being stopped.
