#!/bin/bash

./setlist.tcl slow.set > slow.abc
abcm2ps slow.abc
ps2pdf Out.ps output/Slow.pdf

