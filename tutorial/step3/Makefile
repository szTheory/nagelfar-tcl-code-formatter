NAGELFAR = nagelfar
OPTIONS  =
# Alternative to chose syntax database
#OPTIONS  = -s syntaxdb87.tcl
SRCFILES = apa.tcl bepa.tcl

all: check

myproj_h.syntax: myproj.syntax $(SRCFILES)
	$(NAGELFAR) -header myproj_h.syntax $(OPTIONS) myproj.syntax $(SRCFILES)

check: myproj_h.syntax
	$(NAGELFAR) $(OPTIONS) myproj_h.syntax $(SRCFILES)
