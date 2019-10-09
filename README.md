FAQ
===

What's this?
------------

Dithcord is what you may call a "non-automated bot". It's a bot mainly intended to be controlled manually by a user.

Is it a self-bot?
-----------------

Self-bot is the opposite of what Dithcord is. Self-bot is an automated user account. Dithcord doesn't automate and doesn't use a user account.

So it's more like a 3rd-party Discord client?
---------------------------------------------

Kinda, except Discord's Terms of Service explicitly forbid implementing 3rd-party clients, so we legally can't use their User API. The main differences between bot accounts and user accounts are outlined here: (https://discordapp.com/developers/docs/topics/oauth2#bot-vs-user-accounts)

What can it do? (AKA Roadmap)
-----------------------------

It has five components, neither of which is finished right now :o)

* **Dithcord** - A library with common functions. Uses [Lispcord](https://github.com/lispcord/lispcord) for the protocol implementation. It will probably be possible to use it as a generic Discord bot framework too if you don't like Lispcord itself for some reason.
* **Dithcord-altha** - A library for sending/receiving audio from Discord using ALSA. Unless it's implemented as a part of Lispcord, in which case we'll just use that one. Why ALSA? It's what I use. PipeWire support will be added as soon as its developers release the Pulse Audio-compatible API, in which case we'll hopefully automatically get Pulse Audio support for free. I'm not interested in implementing PA support specifically but contributions are welcome (when we have ALSA at least).
* **Dithcord-CLI** - A command-line interface. Just to get something working and usable.
* **Dithcord-TUI** - An ncurses-based Text User Interface. Think irssi or weechat.
* A GUI. Not even sure what toolkit to use yet.

In the end it should allow you to manually control a bot account, being able to do as much of what a user account can do as possible with a bot account.

How is Dithcord (the library) different fron Lispcord?
------------------------------------------------------

The main difference is that Lispcord supports running several monolithic bots in the same lisp-system while Dithcord supports running a single modular bot. If both suit you then you should probably pick Lispcord to avoid an extra layer you don't need. Also, Dithcord is not a complete abstraction and you'll have to use Lispcord functions anyway.

Also, Lispcord is more imperative while Dithcord is more declarative with all the define-stuff macros.

What's with the lisp?
---------------------

Well, both Dithcord and Lispcord have lots of it.

Dithcord API
============

Special handlers
----------------

:on-load - Called when the module is loaded into the bot, before the bot is connected, after the module's dependencies are loaded.