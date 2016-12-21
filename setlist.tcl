#!/usr/bin/tclsh


set setList { \
	{ "old_hag.abc" "dinny_delaneys.abc" "morrisons.abc" } \
	{ "black_rogue.abc" "dinny_delaneys.abc" "morrisons.abc" } \
	} 

puts $setList

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

	foreach set $setList {

		foreach tuneFile $set {

			set abc [ loadTune $tuneFile ]		

			set abc [ changeTuneIndex $abc $tuneIndex ]

			set abc [ reduceMeasures $abc 4 ]
			
			puts "$abc"

			incr tuneIndex

		}

	}
}

proc generateTunebook { setList } {

	set tuneIndex 1

	foreach set $setList {

		foreach tuneFile $set {

			set abc [ loadTune $tuneFile ]		

			set abc [ changeTuneIndex $abc $tuneIndex ]

			puts "$abc"

			incr tuneIndex

		}
	}
}

generateCheatSheet $setList
#generateTunebook $setList

