.. _inline-comments-label:

Inline Comments
===============

Nagelfar supports having comments inlined in the checked source to help it
check a file.

Whenever <file>.tcl is checked, any <file>.syntax is run through
the syntax checker first.  Thus you can put your comments in such
a separate file instead of your source if that is not suitable.

A comment should start with "##nagelfar" to be recognized as special.
The comment must be a valid Tcl list.

Ignoring messages
^^^^^^^^^^^^^^^^^

.. code:: tcl

 ##nagelfar ignore ?string?
 ##nagelfar filter ?string?

These two are equivalent and adds a message filter rule for the line
following it. The string argument will be part of the filter pattern,
which is a glob pattern built like this: "*Line* $line:*$string*"
If the string is preceded by "N", "W" or "E", anything from that
severity level and down is ignored.
If the string is preceded by an offset like "+2", a line further
down is marked for filtering. No given offset corresponds to "+1".

Examples:

.. code:: tcl

 ##nagelfar ignore 
 set apa [Miffo a b c]
 ##nagelfar ignore Unknown variable
 set apa [lindex $Gurka 1]
 ##nagelfar ignore Expr without braces
 set apa [expr 1 + 2]
 ##nagelfar ignore N

Nagelfar also recognizes "# PRAGMA: nocheck", which is equivalent to
"##nagelfar ignore", and ignores messages on the next line.

Specifying variables
^^^^^^^^^^^^^^^^^^^^

.. code:: tcl

 ##nagelfar variable name ?type?

This will make "name" a known variable and optionally set its type.
Types are still experimental in Nagelfar. The type "varName" can
be used to tell Nagelfar that a variable contains a variable name,
which suppresses some warnings.

Example:

.. code:: tcl

 ##nagelfar variable apaName varName
 set hejsan [set $apaName]

Specifying implicit variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: tcl

 ##nagelfar implictvarcmd pattern var ?var ...?

Some commands will dynamically create variables that are impossible to
predict from static checking. By restricting such usage to a known
pattern in your code, it can become checkable by this annotation.
The pattern is a glob pattern applied to any statement encountered and
if matched will make the listed variables known.

Example:

.. code:: tcl

 ##nagelfar implictvarcmd {dict with *Stat {}} name size value
 dict with fileStat {}
 dostuffwith $name $size $value

Syntax database
^^^^^^^^^^^^^^^

.. code:: tcl

 ##nagelfar syntax cmd tokens
 ##nagelfar subcmd cmd subcmds
 ##nagelfar subcmd+ cmd subcmds
 ##nagelfar option cmd options
 ##nagelfar option+ cmd options
 ##nagelfar return cmd type
 ##nagelfar copy from to

All these provides access directly into the syntax database that
usually is loaded from syntaxdb.tcl.
Check syntaxbuild.tcl for more info.

Examples:

.. code:: tcl

 ##nagelfar syntax binary s x*
 ##nagelfar subcmd binary format scan
 ##nagelfar syntax binary\ scan x x n n*
 ##nagelfar syntax fcopy x x p*
 ##nagelfar option fcopy -size -command

Add to subcmd list, e.g. when using namespace ensemble:

.. code:: tcl

 ##nagelfar subcmd+ string mysubcmd
 ##nagelfar syntax string\ mysubcmd x x

Copy syntax from command, with added option.

.. code:: tcl

 ##nagelfar copy binary mybinary
 ##nagelfar option+ mybinary -mysuperflag

For more examples, use the database browser to see how the comments
would look like for the commands known in the database.

Package handling
^^^^^^^^^^^^^^^^

To mark a package as known, use the following. Any subsequent
package require for this package will assume it is already there.

.. code:: tcl

 ##nagelfar package known snit

To trigger loading of a package database, use the following. It
is equivalent to encountering the same package require in the code.

.. code:: tcl

 ##nagelfar package require snit

Other handling
^^^^^^^^^^^^^^
Nagelfar tries to pick up namespace path commands to track command
resolution. It is possible to manually provide namespace path information,
as shown below. If the namespace is given as "current", the surrounding
namespace where the inline comment resides is used.

.. code:: tcl

 ##nagelfar nspath ns paths
 # A line like this is recognised:
 namespace path [list {*}[namespace path] ::apa]
 # The corresponing inline directive would be:
 ##nagelfar nspath current ::apa
