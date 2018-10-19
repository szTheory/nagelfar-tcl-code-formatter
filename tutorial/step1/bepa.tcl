package require Gurka

proc bepa1 {} {
    bepa2 y
    puts $y
    Gurka::something
}

proc bepa2 {srcName} {
    upvar 1 $srcName src
    set src 5
    apa1
}
