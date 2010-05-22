# This is an experiment to check snit

##nagelfar syntax snit::type x cn
##nagelfar syntax snit::type::method x cv
##nagelfar syntax snit::type::constructor cv
##nagelfar syntax snit::type::destructor cl
##nagelfar syntax snit::type::option x p*

##nagelfar syntax _obj,pdf4tcl s x*
##nagelfar subcmd _obj,pdf4tcl destroy cleanup finish RequireVersion configurelist
##nagelfar syntax _obj,pdf4tcl\ RequireVersion x x
##nagelfar syntax _obj,pdf4tcl\ destroy 0
##nagelfar syntax _obj,pdf4tcl\ cleanup 0
##nagelfar syntax _obj,pdf4tcl\ finish 0
##nagelfar syntax _obj,pdf4tcl\ configurelist x

##nagelfar syntax pdf4tcl::pdf4tcl d=_obj,pdf4tcl p*
##nagelfar option pdf4tcl::pdf4tcl -file
##nagelfar return pdf4tcl::pdf4tcl _obj,pdf4tcl

##nagelfar implicitvar snit::type::pdf4tcl::pdf4tcl self\ _obj,pdf4tcl pdf

snit::type pdf4tcl::pdf4tcl {
    variable pdf
    option -file      -default "" -readonly 1
    constructor {args} {
        $self configurelist $args
    }
    destructor {
        $self finish
        close $pdf(ch)
    }
    method cleanup {} {
        $self destroy
    }
    method RequireVersion {version} {
        if {$version > $pdf(version)} {
            set pdf(version) $version
        }
    }
}

set x [pdf4tcl::pdf4tcl %AUTO% -file xx]
$x cleanup

pdf4tcl::pdf4tcl myobj -file xx
myobj cleanup

