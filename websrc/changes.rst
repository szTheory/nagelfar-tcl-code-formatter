Changes
========

Changes in v1.3 (not released):

* Support multiple plugins.
* Added -pluginpath option.
* New plugin hooks, "writeHeader" and "syntaxComment".
* Include mathop and mathfunc in database.
* Added regexp check. (re token)
* Added multi tokens to support syntax of some commands.
* Database for 8.6 default, 8.7 added, 8.4 removed.
* Allow GUI to add files without extension.
* Added syntax data for text widget.
* Added syntax data for many dict sub commands. [Bug #13]
* Fixed a bad check on constant array index. [Bug #1]

Changes in v1.2.5 (2017-01-09):

* New inline command "vartype" to just annotate a variable with a type. Using "variable" for that purpose could mask bugs.
* New inline command "option+" to handle manually added options. Useful together with "copy" when you extend e.g. a widget.
* New -len option to make Nagelfar check max line length.
* Corrected a bug where trace execution and variable x combination failed.
* Corrected syntax of eval command in sqlite3 database.
* New variable type "script" used to annotate things that build e.g. call-backs. This is used to clean up "No braces around code" notifications.

Changes in v1.2.4 (2016-08-06):

* Support oo::define.

Changes in v1.2.3 (2016-08-05):

* Support namespace path. Added inline directive "nspath".
* Avoid warning with code that comes from a variable. [Bug #10]
* Handle if a word starts with #. [Bug #9]
* Added -idir option to redirect temporary files created during code coverage.
* Added -markupfull option to include stats of covered lines in markup.
* Allow code coverage to run in parallell. [FR #8] Thanks to Sven Beyer.
* Handle all lmap variants, like foreach.
* Handle namespace import with glob pattern. (exports are not tracked so it just assumes existing procs are exported) [Bug #7]
* Do not introduce side effect when instrumenting implicit else. [Bug #5]
* Line number reporting could be wrong with {*} operator. [Bug #6]
* Made a utility for package database creation.
* More package databases (fileutil, textutil, profiler, ftp)

Changes in v1.2.2 (2015-03-08):

* Various bug fixes:
* Handle switch's variable options.
* Handle instance variables in a destructor.
* Handle standard varname method in tcloo.
* Do not consider "-" strange in command name.
* Removed note about unaligned brace in some reasonable cases.
* Handle multiple cv/cl args to a command with a common context.

Changes in v1.2.1 (2015-02-07):

* Extended plugins with hooks for variable read and write.
* Extended plugins with variable info to all hooks.
* Added sqlite3 to package database.

Changes in v1.2 (2013-01-04):

* Added handling of databases for packages. Databases for a few packages like Snit are included.
* Auto-load package definition on package require.
* New plugin system to allow lots of possibilities.
* Handle "dict for" better.
* Handle "try" better.
* Handle "tcl::mathfunc" better.
* Fixed bug where filter pragmas could leak to similar line numbers. [Bug 18486]
* Added note for unescaped close braces.
* Changed inline comment implicitvar to implicitvarns.

Changes in v1.1.12 (2011-11-27):

* Added checks for array/scalar mixup.
* More 8.6 support, more of tcloo handled.
* Command line -s search built-in database too.
* Command line -H added to precede messages with file name.
* Recognize namespace idiom ${ns}::var as non-suspicious.

Changes in v1.1.11 (2010-09-30):

* Do not turn off variable tracking during code coverage instrumentation.
  This was needed to be able to cover OO code. Option -novar only suppresses
  messages now.
* More 8.6 support, e.g. tailcall and more support for OO checking. Still not convenient to check OO though.
* New syntax tokens for command and object definitions, needed to pave the way for OO.
* New inline command "alias" to link from command to command.

Changes in v1.1.10 (2010-05-17):

* Include 8.6 database. Much support to make OO checking possible. Not convenient yet though.
* More 8.5 commands in database. Including msgcat.
* Added HTML output option.
* Added support for partial command tokens, for better checking of callbacks.
* Added note when encountering newline in command subst.
* Added note when encountering expr in an expression.
* New inline command "subcmd+" to handle manually added subcommands, e.g. through namespace ensemble.
* New inline command "copy" to copy syntax from command to command.
* Misc GUI fixes and bug fixes [Bugs 15644, 15645].
* Thanks to Hans Goetz for contributions.

Changes in v1.1.9 (2008-09-05):

* Default database is 8.5 based.
* More 8.5 commands in database, including ttk.
* Detect Ctrl-Z in scripts, notifying about it.
* Use the selected encoding on instrumented file and markup file.
* Support initial "+" in bind scripts. [FR 3893]
* New ##nagelfar nocover pragma.

Changes in v1.1.8 (2007-12-05):

* Added a reset filter option in GUI. [FR 3586]
* Added break button in GUI. [FR 3412]
* Removed old {expand} syntax.
* Added Del button for Db files. [Bug 11109]
* Added percentage in coverage output. [FR 3428]
* Improved error messages for comments in db files. [Bug 11109]
* Check if file is being reinstrumented. [FR 3424]
* Made code coverage count number of runs instead of just run/notrun. [FR 3415]
* Fixed a bug in expression checking. [Bug 11091]
* Check bind scripts in global context. New token "C".
* Fixed edit window startup problem.
* Filter multiple line messages better in GUI. [Bug 10515]
* Corrected syntax for time command. [Bug 10496]

Changes in v1.1.7 (2007-02-23):

* Added sanity check for proc arguments. [FR 3167]
* Read .nagelfarrc from current dir first.
* Added -exitcode. [Sup 102383]
* Added extensions preference. [FR 3102]
* Detect inline style comments in db file. [FR 2541][FR 2938]
* Check for extra quote at end of word. [Bug 9644]
* Detect extra bracketed commands. [FR 2943]
* Check for duplicate files in GUI. [Bug 9709]
* More filter options on GUI. [Bug 9774][Bug 9826]
* Corrected syntax database for regsub. [Bug 9791]
* More fconfigure opts in syntax db. [Bug 9607]
* Added more missing 8.5 features to syntax db. [Bug 10430]
* Thanks to David Cargo for suggestions.

Changes in v1.1.6 (2006-12-03):

* Remember directories between adding files. [Frq 2921]
* Allow to move files in file list with shift-up/down. [Frq 2921]
* Include 8.5 syntax database in distribution.
* Fixed bug remembering global variables. [Bug 9578]
* Support {*} syntax.
* Fixed bug in switch check. [Bug 9147]
* Include Tk's auto_loaded commands in syntax db.

Changes in v1.1.5 (2006-10-15):

* Added proc argument name sanity checks.
* Fixed header generation bug. [Bug 8500]
* Fixed upvar bug. [Bug 8534]
* Fixed namespace resolution bug. [Bug 8538]
* Check namespace eval better. [Bug 8539]
* Fixed bad close brace alignment warning. [Bug 8537]
* Recognize FRINK style inline comments. [FR 2540]
* Allow level in inline filter comments.

Changes in v1.1.4 (2006-07-05):

* Improved 8.5 support, allowing source -encoding in instrumenting
  and added more new commands to the syntax database.
* Allow nagelfar to be loaded embedded.

Changes in v1.1.3 (2006-06-02):

* Instrument a missing "else" in code coverage, to get branch
  coverage.
* On Windows, when run in wish there is no stdout so always start
  in gui mode.
* Made it possible to remove files from database list.
* Support vim as editor.
* Support different tab settings.
* Goto next error, and text search in result window.
* Put less important info in gray.
* Thanks to Arjen Markus and Andreas Leitgeb for suggestions.

Changes in v1.1.2 (2005-01-31):

* Added -header flag to generate a syntax file for one or more
  tcl files.
* Added the option to use emacs to view files instead of the
  internal editor.
* Added -quiet flag to suppress some output.
* Added -glob flag.
* Thanks to Yiftach Tzori and Phil Wise for contributions.

Changes in v1.1.1 (2005-01-02):

* Fixed a bug that prevented instrumenting multiple files.
* Preserve header and permissions in instrumented file to allow
  an executable file to remain executable after instrumentation.

Changes in v1.1 (2004-12-22):

* Added support for code coverage instrumentation.
* Added -strictappend option to enforce setting a var before
  (l)appending to it.
* Bug fixes in variable and upvar handling.
* Added option to backup file when saving from Edit Window.
* Thanks to Uwe Koloska for suggestions and fixes.

Changes in v1.0.2 (2004-09-02):

* Added database browser for easier access to examples.
* Fixed some bugs in resolving namespace proc names.
* Always use 2-pass analysis.
* Track interp alias "commands".

Changes in v1.0.1 (2004-06-13):

* Fixed some bugs in {expand} handling.  It is still rather incomplete,
  examples of live code that needs better handling are welcome.  Note
  that to check {expand} Nagelfar must be run in an 8.5 interpreter,
  and the syntax database must be generated from 8.5 (the distributed
  syntax database is currently from 8.4.6).

Changes in v1.0 (2004-05-01):

* Add multiple files in file add dialog.
* Improved option and subcommand checking. Added more info about them
  to the syntax database.
* Added more ways to use inline comments to help Nagelfar, including
  an ignore comment to skip messages for known issues.

Changes in v1.0b3 (2004-03-23):

* Fixed a bug in option checking where glob chars disturbed things.
* Also make sure that option checking is not invoked on args that
  cannot be options due to their placement.

Changes in v1.0b2 (2004-02-09):

* Added -encoding option for scripts that are not in system encoding.
* Added registry setting for Windows.
* A few minor bugs fixed.

Changes in v1.0b1 (2004-01-29):

* Recognize if 0 {...} as a comment.
* Added a check for bad comments in constant lists.
* Added a 2-pass proc checking to improve things when procs are used
  before they are defined in a file.
* Optimized, improved speed by about 35%.

Changes in v0.9 (2003-12-11):

* Improved expression checking.
* Added upvar detection to handle call-by-name better.
* Added a check in the edit window to simplify checking of clips
  that are not in files.

Changes in v0.8 (2003-08-14):

* Bug fixes in options checking and proc checking.
* GUI polishing.

Changes in v0.7 (2003-07-23):

* Tclkit support. Removed FreeWrap support.
* Requires Tcl/Tk 8.4.
* More knowledge about options in syntax databases.
* Some GUI polish including a progress bar and context menu.
* Fixed a bug where the script's own procs were not checked properly.
* Added a severity level to each message (Note/Warning/Error) and a
  severity level filter on output.

Changes in v0.6 (2003-07-08):

* The application got its name.
* Added -filter option to suppress messages.

Changes in v0.5 (2003-02-14):

* Made it work when wrapped with FreeWrap.
  This includes wrapping the syntax database and supporting
  `TkDnd <http://sourceforge.net/projects/tkdnd/>`_
  if properly placed.

Changes in v0.4 (2002-11-14):

* Added option to skip variable check.
* Added option to enforce 'else' keyword.
* Some message improvements and minor bug fixes.

Changes in v0.3 (2002-09-02):

* Made procedure checking namespace-aware.
* Some improvements in syntax database and check engine.

Changes in v0.2 (2002-08-28):

* Added a GUI, which can be used if you run with wish or in Tcl8.4.
  It is still a command line tool but invokes the GUI if no arguments are
  given or the option -gui is used.
* Changed how syntax databases are located, which simplifies usage a bit.
* Sorts output on line numbers to make it easier to follow.
* Improved some error messages.
