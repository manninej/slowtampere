#!/bin/bash

if [ -f "$1.set" ]; then
	echo "gene"

	./setlist.tcl $1.set > $1.abc
	abcm2ps $1.abc -O- > $1.ps
	abcm2ps $1.abc -O- | ps2pdf - $1.pdf
#	abcm2ps $1.abc -O- | pstopdf -o $1.pdf
fi

