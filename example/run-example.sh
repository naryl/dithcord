#!/bin/sh

sbcl \
	--eval '(ql:quickload "dithcord")' \
	--eval '(read-line)' \
	--load $1
