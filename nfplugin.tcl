##Nagelfar Plugin : Check of Nagelfar's own source

proc statementWords {words info} {
    set caller [dict get $info caller]
    set callee [lindex $words 0]

    # WA and checkCommand is bit dirty and must assume certain callers.
    # This checks that.
    if {$callee in {WA checkCommand}} {
	if {$caller ni {checkCommand parseStatement}} {
	    return [list error "$callee called from bad place"]
	}
    }
    return
}
