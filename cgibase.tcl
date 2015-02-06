#!/bin/env tclsh

# map specail chars for HTML
proc m {str} {
    set map {< &lt; > &gt; & &amp;}
    return [string map $map $str]
}

# Start of output
proc cgiInit {} {
    puts "Content-type: text/html"
    puts ""
    puts "<html>"
    puts "<head>"
    puts "<title>Nagelfar Test</title>"
    puts "</head>"
    puts "<body>"
}
# End of output
proc cgiEnd {} {
    puts "</body>"
    puts "</html>"
}

# Helper to get debug info in output
proc cgiDebug {} {
    puts "<h2>Debug info</h2>"
    puts "Detected Tcl version [info patchlevel]<p>"
    puts "<h2>Detected Environment</h2>"
    puts "<ul><li>"
    foreach {key} [lsort -dict [array names ::env]] {
        puts "<li>[m $key] = [m $::env($key)]</li>"
    }
    puts "</ul>"

    puts "<h2>Detected Packages</h2>"
    catch {package require gurka}
    puts "<ul><li>"
    puts [join [lsort -dict [package names]] "</li><li>"]
    puts "</li></ul>"
}

# Decode the POST query string
proc cgiDecode {str} {
    # rewrite "+" back to space
    # protect \ from quoting another '\'
    set str [string map [list + { } "\\" "\\\\"] $str]

    # Take care of newline
    set str [string map {%0D%0A \n} $str]

    # prepare to process all %-escapes
    regsub -all -- {%([A-Fa-f0-9][A-Fa-f0-9])} $str {\\u00\1} str

    # process \u unicode mapped chars
    return [subst -novar -nocommand $str]
}

# Generate a table combining source and messages
proc cgiResultTable {lines result} {
    puts "<h2>Experimental Result Table</h2>"
    puts {<table cellpadding="2" cellspacing="0" border="1">}
    puts "  <tbody>"
    puts "    <tr>"
    puts "      <th>Script</th>"
    puts "      <th>Check Result</th>"
    puts "    </tr>"
    puts "    <tr>"

    puts {<td style="vertical-align: top; white-space: nowrap;"><pre>}
    set n 1
    foreach line $lines {
        set line [Text2Html $line]
        if {[regexp {^\s*#} $line]} {
            set line "<span style=\"color: #b22222\">$line</span>"
        } elseif {[regexp {^([^#]*)(;\#.*)$} $line -> pre post]} {
            set line "$pre<span style=\"color: #b22222\">$post</span>"
        }
        puts [format "<span style=\"color: #808080\">%3d</span>  %s" $n $line]
        incr n
    }
    puts "</pre></td>"

    puts {<td style="vertical-align: top; white-space: nowrap;"><pre>}
    set n 1
    foreach line $result {
        if {[regexp {^Line\s+(\d+)} $line -> errLine]} {
            while {$errLine > $n} {
                puts ""
                incr n
            }
        }
        set line [Text2Html $line]
        puts $line
        incr n
    }
    puts "</pre></td>"

    puts "</tr>"
    puts "</tbody>"
    puts "</table>"
}

# Main CGI function, this is called from the end of the script.
proc cgiMain {} {
    cgiInit

    #puts "<h2>STDIN</h2>"
    set x [read stdin]
    #puts "Got [string length $x] characters<br>'[m [string range $x 0 100]]'"
    set script ""
    foreach var [split $x "&"] {
        if {[string match "script=*" $var]} {
            set script [string range $var 7 end]
            break
        }
    }
    # Decode it
    set script [cgiDecode $script]
    set script [string trimright $script]

    set lines [split $script \n]
    # Limit run time
    set lines [lrange $lines 0 100]
    set script [join $lines \n]

    #set ::Prefs(html) 1
    if {[catch {synCheck $script $::CgiDb 1} res]} {
        puts "<strong>ERROR WHILE RUNNING CHECK</strong><p>"
        set res [list $res]
    }

    puts "<h2>Result</h2>"
    puts "<pre>"
    foreach line $res {
        puts [Text2Html $line]
    }
    puts "</pre>"

    puts "<h2>Given Script</h2>"
    puts "<pre>"
    set ln 0
    foreach line $lines {
        incr ln
        puts "<font color=gray>[format %4d: $ln]</font> [Text2Html $line]"
    }
    puts "</pre>"

    cgiResultTable $lines $res

    #cgiDebug
    cgiEnd
}

set ::CgiDb {
    # Include syntaxdb here
}

# Prepare to run nagelfar embedded
set ::Nagelfar(embedded) 1
set _nagelfar_test 1
set gurka 1

# Include Nagelfar source here

StartUp
cgiMain
