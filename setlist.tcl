#!/usr/bin/tclsh

proc loadSetList { setFile } {

	set handle [ open "$setFile" r ]

	set setList [ list ]

	while {1} {

		set line [gets $handle]

		if {[eof $handle]} {
			close $handle
			break
		}

		set parts [ split $line "|" ]
		set setTitle "\"[ string trim [ lindex $parts 0 ] ]\""

		set setTunes [ list ]

		foreach tuneFile [ split [ lindex $parts 1 ] "," ] {
		
			lappend setTunes [ string trim $tuneFile ]
		}

		set setInfo [ list $setTitle $setTunes ]

		lappend setList $setInfo
	}

	return $setList
}

proc loadTune { tuneFile } {

	set handle [ open "abc/$tuneFile" r ]

	set data [ read $handle ]

	close $handle

	return $data
}

proc changeTuneIndex { abc newIndex } {

	return [ regsub "^X:1" $abc "X:$newIndex" ]
}

proc reduceMeasures { abc numberOfMeasures } {

	set lines [ split $abc "\n" ]

	set output ""

	foreach line $lines {

		if { [ regexp "^\[A-Z\]:.*" $line ] } {

			append output "$line\n"

		} else {

			set measures [ split $line "|" ]

			foreach measure $measures {

				if { $measure != "" && $numberOfMeasures > 0 } {

					set measure [ regsub ":" $measure "" ]

					append output "$measure|"

					incr numberOfMeasures -1
				}
			}
		}
	}

	append output "\n"

	return $output
}

proc generateCheatSheet { setList } {

	set tuneIndex 1
	set setNumber 1

	foreach set $setList {

		set setName [ lindex $set 0 ]

		puts "%%center #$setNumber - $setName"

		foreach tuneFile [ lindex $set 1 ] {

			set abc [ loadTune $tuneFile ]		

			set abc [ changeTuneIndex $abc $tuneIndex ]

			set abc [ reduceMeasures $abc 2 ]
			
			puts "$abc"

			incr tuneIndex


		}

		incr setNumber

		if { $setNumber % 2 == 1 } {
			puts "%%newpage"
		}
	}
}

proc generateTunebook { setList } {

	set tuneIndex 1
	set setNumber 1

	foreach set $setList {

		set setName [ lindex $set 0 ]

		puts "%%center #$setNumber - $setName"

		foreach tuneFile [ lindex $set 1 ] {

			set abc [ loadTune $tuneFile ]		

			set abc [ changeTuneIndex $abc $tuneIndex ]

			puts "$abc"

			incr tuneIndex

		}

		puts "%%newpage"

		incr setNumber
	}
}

##############################################################################
# Actual script execution
##############################################################################

if { $argc == 0 } {
	puts ""
	puts "Usage:"
	puts ""
	puts "  Generate setlist:"
	puts "    $ setlist.tcl setlist.set > full.abc"
	puts ""
	puts "  Generate cheatsheet:"
	puts "    $ setlist.tcl -c setlist.set > cheat.abc"
	puts ""
	exit
}

set generateCheat 0

foreach param $argv {

	if { $param == "-c" } {

		set generateCheat 1

	} else {

		set fileName $param
	}
}

set list [ loadSetList $fileName ]

# Styling
puts "%%textfont Times-Roman 20"
puts "I:titlefont Times-Roman 14"
puts "%%pdfmark 1"

if { $generateCheat } {

	generateCheatSheet $list

} else {

	generateTunebook $list
}

