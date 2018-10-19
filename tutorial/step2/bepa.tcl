package require Gurka

proc bepa1 {} {
    bepa2 y
    puts $y
    Gurka::something
}

##nagelfar syntax bepa2 n
proc bepa2 {srcName} {
    upvar 1 $srcName src
    set src 5
    apa1
}
