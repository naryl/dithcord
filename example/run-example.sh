#!/bin/sh

sbcl --eval '(ql:quickload "dithcord")' \
	--eval '(ql:quickload "swank")' \
	--eval '(swank:create-server :dont-close t)' \
	--load $1
