#----------------------------------------------------------------------
#  Nagelfar, a syntax checker for Tcl.
#  Copyright (c) 2013, Peter Spjuth
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; see the file COPYING.  If not, write to
#  the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
#  Boston, MA 02111-1307, USA.
#
#----------------------------------------------------------------------
# plugin.tcl
#----------------------------------------------------------------------

proc PluginSearchPath {} {
    set dirs [list . ./plugins]
    lappend dirs [file join $::thisDir .. ..]
    lappend dirs [file join $::thisDir .. .. plugins]
    lappend dirs [file join $::thisDir .. plugins]
    foreach d $::Nagelfar(pluginPath) {
	lappend dirs $d
    }
    return $dirs
}

# Locate plugin source
proc LocatePlugin {plugin} {
    set src ""
    set dirs [PluginSearchPath]

    foreach dir $dirs {
        set dir [file normalize $dir]
        set files {}
        lappend files [file join $dir $plugin]
        lappend files [file join $dir $plugin.tcl]
        foreach file $files {
            if {![file exists   $file]} continue
            if {![file isfile   $file]} continue
            if {![file readable $file]} continue
            set ch [open $file r]
            set data [read $ch 20]
            close $ch
            if {[string match "##Nagelfar Plugin*" $data]} {
                set src $file
                break
            }
        }
        if {$src ne ""} break
    }
    return $src
}

proc createPluginInterp {plugin} {
    set src [LocatePlugin $plugin]

    if {$src eq ""} {
        return ""
    }
    # Create interpreter
    set pi [interp create -safe]

    # Load source
    $pi invokehidden -global source $src
    $pi eval [list set ::WhoAmI [file rootname [file tail $src]]]
    interp share {} stdout $pi

    # Expose needed commands
    #interp expose $pi fconfigure ;# ??
    interp hide $pi close

    # Set global variables
    foreach func {statementRaw statementWords earlyExpr lateExpr varWrite
                  varRead syntaxComment
    } {
	if {[$pi eval info proc $func] ne ""} {
            # var names start with uppercase
            set func [string toupper $func 0 0]
            lappend ::Nagelfar(pluginHooks$func) $pi
            set ::Nagelfar(plugin$func) 1
	}
    }
    return $pi
}

proc resetPluginData {} {
    foreach func {StatementRaw StatementWords EarlyExpr LateExpr VarWrite
                  VarRead SyntaxComment
    } {
        set ::Nagelfar(pluginHooks$func) {}
        set ::Nagelfar(plugin$func) 0
    }
    set ::Nagelfar(pluginInterp) {}
}

proc initPlugin {} {
    resetPluginData
    foreach plugin $::Nagelfar(plugin) {
        set pinterp [createPluginInterp $plugin]
        if {$pinterp eq ""} {
            puts "Bad plugin: $plugin"
            printPlugins
            exit 1
        }
        lappend ::Nagelfar(pluginInterp) $pinterp
        set ::Nagelfar(pluginNames,$pinterp) $plugin
    }
}

proc finalizePlugin {} {
    foreach pi $::Nagelfar(pluginInterp) {
        if {[$pi eval info proc finalizePlugin] ne ""} {
            set x [$pi eval finalizePlugin]
            if {[catch {llength $x}] || ([llength $x] % 2) != 0} {
                errorMsg E "Plugin $::Nagelfar(pluginNames,$pi) returned malformed list from finalizePlugin" 0
            } else {
                foreach {cmd value} $x {
                    switch $cmd {
                        error   { errorMsg E $value 0 }
                        warning { errorMsg W $value 0 }
                        note    { errorMsg N $value 0 }
                        default {
                            errorMsg E "Plugin $::Nagelfar(pluginNames,$pi) returned bad keyword '$cmd' from finalizePlugin" 0
                        }
                    }
                }
            }
        }

        interp delete $pi
        unset ::Nagelfar(pluginNames,$pi)
    }

    resetPluginData
}

proc pluginHandleWriteHeader {ch} {
    foreach pi $::Nagelfar(pluginInterp) {
        if {[$pi eval info proc writeHeader] ne ""} {
            set x [$pi eval writeHeader]
            foreach value $x {
                if {![regexp "^\#\#nagelfar\[^\n\]" $value]} {
                    errorMsg E "Plugin $::Nagelfar(pluginNames,$pi) returned illegal comment" 0
                } else {
                    puts $ch $value
                }
            }
        }
    }
}

proc printPlugin {plugin} {
    set src [LocatePlugin $plugin]
    if {$src eq ""} {
        printPlugins
        return
    }
    set ch [open $src]
    puts -nonewline [read $ch]
    close $ch
}

proc listPlugins {} {
    set dirs [PluginSearchPath]

    foreach dir $dirs {
        set dir [file normalize $dir]
        set files [glob -nocomplain [file join $dir *.tcl]]
        foreach file $files {
            set file [file normalize $file]
            if {[info exists done($file)]} continue
            if {![file exists $file]} continue
            if {![file isfile $file]} continue
            if {![file readable $file]} continue

            set done($file) 1
            set ch [open $file r]
            set data [read $ch 200]
            close $ch
            if {[regexp {^\#\#Nagelfar Plugin :(.*?)(\n|$)} $data -> descr]} {
                set result([file rootname [file tail $file]]) $descr
            }
        }
    }
    set resultSort {}
    foreach elem [lsort -dictionary [array names result]] {
        lappend resultSort $elem $result($elem)
    }
    return $resultSort
}

proc printPlugins {} {
    set plugins [listPlugins]
    if {[llength $plugins] == 0} {
        puts "No plugins found."
        return
    }
    puts "Available plugins:"
    foreach {plugin descr} $plugins {
        puts "Plugin \"$plugin\" : $descr"
    }
}

# Generic handler to call plugin
proc PluginHandle {pi what indata outdataName knownVarsName index} {
    upvar 1 $outdataName outdata $knownVarsName knownVars

    set outdata $indata
    set info [list namespace [currentNamespace] \
                      caller [currentProc] \
                      file $::currentFile \
                      firstpass $::Nagelfar(firstpass) \
		      vars $knownVars]

    set x [$pi eval [list $what $indata $info]]

    if {[catch {llength $x}] || ([llength $x] % 2) != 0} {
        errorMsg E "Plugin $::Nagelfar(pluginNames,$pi) returned malformed list from $what" $index
        return
    }

    foreach {cmd value} $x {
        switch $cmd {
            replace {
                set outdata $value
            }
            comment {
                foreach line [split $value \n] {
                    checkComment $line $index knownVars
                }
            }
            error   {errorMsg E $value $index 1}
            warning {errorMsg W $value $index 1}
            note    {errorMsg N $value $index 1}
            default {
                errorMsg E "Plugin $::Nagelfar(pluginNames,$pi) returned bad keyword '$cmd' from $what" $index
            }
        }
    }
}

# This is called to let a plugin react to a statement, pre-substitution
proc pluginHandleStatementRaw {stmtName knownVarsName index} {
    upvar 1 $stmtName stmt $knownVarsName knownVars

    set outdata $stmt
    foreach pi $::Nagelfar(pluginHooksStatementRaw) {
	PluginHandle $pi statementRaw $stmt outdata knownVars $index
    }
    set stmt $outdata
}

# This is called to let a plugin react to a statement, pre-substitution
proc pluginHandleStatementWords {wordsName knownVarsName index} {
    upvar 1 $wordsName words $knownVarsName knownVars

    foreach pi $::Nagelfar(pluginHooksStatementWords) {
	PluginHandle $pi statementWords $words outdata knownVars $index
	# A replacement must be a list
	if {[string is list $outdata]} {
	    set words $outdata
	} else {
	    errorMsg E "Plugin $::Nagelfar(pluginNames,$pi) returned malformed replacement from statementWords" $index
	}
    }
}

# This is called to let a plugin react to an expression, pre-substitution
proc pluginHandleEarlyExpr {expName knownVarsName index} {
    upvar 1 $expName exp $knownVarsName knownVars

    set outdata $exp
    foreach pi $::Nagelfar(pluginHooksEarlyExpr) {
	PluginHandle $pi earlyExpr $exp outdata knownVars $index
    }
    set exp $outdata
}

# This is called to let a plugin react to an expression, post-substitution
proc pluginHandleLateExpr {expName knownVarsName index} {
    upvar 1 $expName exp $knownVarsName knownVars

    foreach pi $::Nagelfar(pluginHooksLateExpr) {
	PluginHandle $pi lateExpr $exp outdata knownVars $index

        # A replacement expression must not have commands in it
        if {$exp ne $outdata} {
            # It has been replaced
            if {[string first "\[" $outdata] == -1} {
                set exp $outdata
            } else {
                errorMsg E "Plugin $::Nagelfar(pluginNames,$pi) returned malformed replacement from lateExpr" $index
            }
	}
    }
}

# This is called to let a plugin react to a variable write
proc pluginHandleVarWrite {varName knownVarsName index} {
    upvar 1 $varName var $knownVarsName knownVars

    foreach pi $::Nagelfar(pluginHooksVarWrite) {
        PluginHandle $pi varWrite $var outdata knownVars $index
        set var $outdata
    }
}

# This is called to let a plugin react to a variable read
proc pluginHandleVarRead {varName knownVarsName index} {
    upvar 1 $varName var $knownVarsName knownVars

    foreach pi $::Nagelfar(pluginHooksVarRead) {
        PluginHandle $pi varRead $var outdata knownVars $index
        set var $outdata
    }
}

# This is called to let a plugin see syntax comments
proc pluginHandleComment {type opts} {
    set res false
    foreach pi $::Nagelfar(pluginHooksSyntaxComment) {
	if {[$pi eval syntaxComment $type $opts]} {
	    set res true
	}
    }
    return $res
}
