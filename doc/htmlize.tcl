#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" "$@"

set cho [open doc.html w]

set labels {Messages {Syntax Databases} {Inline Comments} {Call By Name} {Syntax Tokens} {Code Coverage} {Plugins}}
set files {messages.txt syntaxdatabases.txt inlinecomments.txt call-by-name.txt syntaxtokens.txt codecoverage.txt plugins.txt}

puts $cho "<html>"
puts $cho "<head>"
puts $cho "  <title>Nagelfar - Documentation</title>"
puts $cho ""      
puts $cho "  <meta http-equiv=\"content-type\""
puts $cho " content=\"text/html; charset=ISO-8859-1\">"
puts $cho "</head>"
puts $cho "<body>"
puts $cho "<h1><a href=\"index.html\">Nagelfar</a> - Documentation</h1>"
foreach label $labels {
    puts $cho "<a href=\"#Nagelfar$label\">$label</a><br>"
}

foreach label $labels file $files {
    puts $cho "<a name=\"Nagelfar$label\"></a><h2>$label</h2>"

    set ch [open $file r]
    set lastbreak 0
    set pre 0
    while {[gets $ch line] != -1} {
	set thisbreak 0
	set line [string trimright $line]
	if {$line eq ""} {
	    set line "<p>"
	    set thisbreak 1
	    if {$pre} {
		set line "</pre>"
	    }
	    set pre 0
	}
	# Handle some known markup
	set map { \\u003c &lt; \\u003e &gt; }
	set line [string map $map $line]
	# Handle embedded backslash-subst
	#set line [subst -nocommand -novar $line]
	# 
	if {[string index $line 0] eq " " && !$lastbreak && !$pre} {
	    set line "<br>$line"
	}
	if {[string index $line 0] in {\# % $ *} || $pre} {
	    if {!$pre} {
		set line "<pre>$line"
	    }
	    set pre 1
	}
	
	puts $cho $line
	set lastbreak $thisbreak
    }
    if {$pre} {
	puts $cho "</pre>"
	set pre 0
    }
    close $ch
}

puts $cho "</body>"
puts $cho "</html>"

close $cho
