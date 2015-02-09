Features
========

* Written in pure Tcl/Tk.  No compilation.  If you can run Tcl you can run
  Nagelfar.
* Extendible.  You can add to the syntax database, or let the tool use
  Tcl's introspection to extract syntax information from any Tcl
  interpreter.  Thus you can test scripts for applications using Tcl as
  script language.
* Plugins. Even more extendible through plugins that can hook up at certain
  points in the check flow and do custom checking.
* Severity level filter and glob matching filters to remove errors
  known to be OK.
* View and edit the checked source directly in Nagelfar.
* Inline comments can help Nagelfar do a better job.
* Code coverage instrumentation.  Provides help for simple code coverage
  analysis.

Example
-------
To get a feeling of what it can do, here is a test script that is part of 
the distribution with errors it can detect, and the output from the tool.

.. raw:: html
   :file: ../misctests/test.html
