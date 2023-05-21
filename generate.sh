#!/bin/bash

if [ -f "$1" ]; then
	./setlist.tcl $1.set > $1.abc
	abcm2ps $1.abc -O- | pstopdf -o $1.pdf
fi

