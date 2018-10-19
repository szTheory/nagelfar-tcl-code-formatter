# This Makefile is not part of the tutorial. It is a helper to build the
# tutorial files.

all: step2 step3

step2: step2/Makefile step2/apa.tcl step2/bepa.tcl

step2/Makefile : step1/Makefile
	awk '/\(OPTIONS\)/ {print "\t$$(NAGELFAR) $$(OPTIONS) myproj.syntax $$(SRCFILES)";next} ; {print}' < step1/Makefile > step2/Makefile

step2/apa.tcl : step1/apa.tcl
	awk '{print}' < step1/apa.tcl > step2/apa.tcl

step2/bepa.tcl : step1/bepa.tcl
	awk '/proc bepa2/ {print "##nagelfar syntax bepa2 n"} ; {print}' < step1/bepa.tcl > step2/bepa.tcl


step3: step3/Makefile step3/apa.tcl step3/bepa.tcl step3/myproj.syntax

step3/Makefile : step2/Makefile
	awk '/check:/ {print $$0, "myproj_h.syntax";next}; /\(NAGELFAR\)/ {print "\t$$(NAGELFAR) $$(OPTIONS) myproj_h.syntax $$(SRCFILES)";next};{print}; /all:/ {print ""; print "myproj_h.syntax: myproj.syntax $$(SRCFILES)"; print "\t$$(NAGELFAR) -header myproj_h.syntax $$(OPTIONS) myproj.syntax $$(SRCFILES)"}' < step2/Makefile > step3/Makefile

step3/myproj.syntax : step2/myproj.syntax
	awk '{print}' < step2/myproj.syntax > step3/myproj.syntax

step3/apa.tcl : step2/apa.tcl
	awk '{print}' < step2/apa.tcl > step3/apa.tcl

step3/bepa.tcl : step2/bepa.tcl
	awk '{print}' < step2/bepa.tcl > step3/bepa.tcl


changes: step2/changes.pdf  step3/changes.pdf

step2/changes.pdf:
	diff -u -x *.txt -x *.pdf step1 step2 | eskil - -printpdf step2/changes.pdf
step3/changes.pdf:
	diff -u -x *.txt -x *.pdf step2 step3 | eskil - -printpdf step3/changes.pdf
