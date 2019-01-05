.. highlightlang:: tcl

.. |nbsp| unicode:: 0xA0
   :trim:

Object Orientation
==================

Introduction
------------

The main problem with checking OO-style code is lines like this:

.. code:: tcl

 $obj dosomething $arg

Since Nagelfar does not know the command, it does not know the syntax
for it, and specially if an argument is a code block, it will not know
that it should check into it.

Basically what is needed is types.  If the type of $obj is known it
can be checked.
By introducing return types of commands and types of variables code
like this becomes checkable:

.. code:: tcl

 set w [frame .f]
 $w configure -apa hej

First Example
^^^^^^^^^^^^^

If you have a command ``myCmd`` that returns an object which has a ``foreach``
loop method, the following are the basic steps needed to get going.

.. code:: tcl

 set o [myCmd stuff]
 $o foreach x {
     puts $x
 }

First give your object type a name. It should be prefixed with the magic
string "_obj,". Let's call it "myObj".

Define a return type to ``myCmd`` with the object type.

``##nagelfar return myCmd _obj,myObj``

Define this object type as a command with a sub-command (a.k.a method)

``##nagelfar syntax _obj,myObj s x*``

Define the list of valid sub-commands.

``##nagelfar subcmd _obj,myObj foreach configure dostuff``

Define the syntax for a specific subcommand.

``##nagelfar syntax _obj,myObj\ foreach n c``


OO Systems
----------

Different common OO systems needs different handling.
Nagelfar has some built in knowledge about some of them that simplifies
using them.

For now, see the ootest directory in Nagelfar's source for some notes.

TclOO
^^^^^

Included in any 8.6+ database.

To be written...

Snit
^^^^

Included in packagedb/snitdb.tcl.

To be written...

ITcl
^^^^

To be written...

TDBC
^^^^

To be written...
