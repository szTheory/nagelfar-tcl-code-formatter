USING HEADER FILE

The next step is generat a common header file to cover all your source files.
This is so Nagelfar will know about all procs in all files so that calls
between files are recognised properly.

When -header <file> is used, Nagelfar will process all files and write the resulting
knowledge about procedures to the header file. During this process many error checks
are suppressed to keeps things a bit more quiet.
