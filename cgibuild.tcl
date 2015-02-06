#!/usr/bin/env tclsh
set ch [open cgibase.tcl r]
set d1 [read $ch]
close $ch

set ch [open nagelfar.tcl r]
set d2 [read $ch]
close $ch

set ch [open syntaxdb.tcl r]
set d3 [read $ch]
close $ch

set d1 [string map [list "# Include syntaxdb here" $d3] $d1]
set d1 [string map [list "# Include Nagelfar source here" $d2] $d1]

set ch [open web/cgi-bin/cginf.tcl w]
puts $ch $d1
close $ch
exec chmod 775 web/cgi-bin/cginf.tcl
