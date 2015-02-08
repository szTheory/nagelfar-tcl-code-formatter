.. Nagelfar documentation master file, created by
   sphinx-quickstart on Sun Feb  8 19:37:40 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Nagelfar's documentation!
====================================

Contents:

.. toctree::
   :maxdepth: 2

   features              
   plugins
   changes


About Nagelfar
==============
In 1999 I got an idea about how I wanted a syntax checker to work,
and that led to a couple of evenings of massive hacking.  After that
it mainly collected dust for a few years before it caught my interest
again.  This had a lot to do with a synthesis script crashing due to
a misspelled variable after running for 30 hours.

After some regular usage by me it is getting stable and can catch a lot
of common errors.

Nagelfar sometimes uses coding style to help checking code.  Some constructs
that are perfectly legal Tcl gives warnings just because they deviate
from what is "normal".  For example, it checks brace indentation,
braced expressions and enforces the *else* keyword.

Naturally Nagelfar expects the coding style of its author so if you
do things differently, you may get false errors.  I am very interested
in hearing about such things to be able to make Nagelfar more general.

Any feedback, good or bad, can be sent to
<peter *dot* spjuth *at* gmail *dot* com>

`See also this page for other syntax checkers. <http://wiki.tcl.tk/3162>`_

The name
--------

Pronunciation: Both a:s are pronounced like in "far".  The g is hard.  Stress
on the first syllable.  That should get you close enough :-).

Nagelfar is the name of a ship in Nordic mythology.  It is made out of dead
people's untrimmed nails (nail == nagel) and when finished the bad guys will
set it to sea and destroy the world.  So if you die with untrimmed nails,
you bring the world closer to its end.  What that has to do with syntax
checking is hard to say, but keeping nails and code in shape could be
a connection.  There is also a Swedish word "nagelfara" which means
"examine thoroughly" but that has nothing to do with this tool.

Download
--------

Is available from the
`Project page <https://sourceforge.net/projects/nagelfar/files/>`_
, including as a Starkit and as Starpacks for Windows, Linux and Solaris.

Any of the files can be unwrapped by sdx to get the source.

The licence is GPL.

More information about `Starkits <http://wiki.tcl.tk/starkit>`_
and `Starpacks <http://wiki.tcl.tk/starpack>`_.

Demo
--------

.. raw:: html

 <form action="../cgi-bin/cginf.tcl" method="POST">
 Script: (limited to 100 lines for now):<br>
 <textarea name="script" rows="20" cols="80">
 puts "Hello World"
 set bepa 1
 set cepa bepa
 set depa $cep
 set epa
 set $depa apa
 </textarea>
 <br><br>
 <input type="submit" value="Check">
 </form>


.. Indices and tables
.. ==================

.. * :ref:`genindex`
.. * :ref:`search`
