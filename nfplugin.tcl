##Nagelfar Plugin : Check of Nagelfar's own source

proc statementWords {words info} {
    set caller [dict get $info caller]
    set callee [lindex $words 0]
    set res {}

    # WA and checkCommand is bit dirty and must assume certain callers.
    # This checks that.
    if {$callee in {WA checkCommand}} {
	if {$caller ni {checkCommand parseStatement checkSpecial}} {
	    return [list error "$callee called from bad place"]
	}
    }
    if {$callee in {checkSpecial}} {
	if {$caller ni {parseStatement}} {
	    return [list error "$callee called from bad place"]
	}
    }
    # Experiment with coding standard
    if {$callee eq "if"} {
        set e [lindex $words 1]
        if {[regexp {\{(\s*)!(\s*)\[} $e -> pre post]} {
            # Trying two possible rules for whitespace
            if 1 {
                if {$pre ne "" || $post ne ""} {
                    lappend res warning
                    lappend res "Not (!) should not be surrounded by space"
                }
            } else {
                if {$pre ne " " || $post ne " "} {
                    lappend res warning
                    lappend res "Not (!) should be surrounded by one space"
                }
            }
        }
    }
    return $res
}
