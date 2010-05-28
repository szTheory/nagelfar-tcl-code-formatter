# This is an experiment to check oo in 8.6

# Define a standard class command for convenience

##nagelfar syntax _stdclass s x*
##nagelfar subcmd _stdclass create new destroy variable
##nagelfar syntax _stdclass\ create dc=_obj,_stdclass x?
##nagelfar return _stdclass\ create _obj,_stdclass
##nagelfar syntax _stdclass\ new x?
##nagelfar return _stdclass\ new _obj,_stdclass
##nagelfar syntax _stdclass\ destroy 0
##nagelfar syntax _stdclass\ variable n*

# Define the class command

##nagelfar copy _stdclass Account
##nagelfar return Account\ create _obj,Account
##nagelfar return Account\ new _obj,Account

oo::class create Account {
    constructor {{ownerName undisclosed}} {
        my variable total overdrawLimit owner
        set total 0
        set overdrawLimit 10
        set owner $ownerName
    }
    method deposit amount {
        my variable total
        set total [expr {$total + $amount}]
    }
    method withdraw amount {
        my variable total overdrawLimit
        if {($amount - $total) > $overdrawLimit} {
            error "Can't overdraw - total: $total, limit: $overdrawLimit"
        }
        set total [expr {$total - $amount}]
    }
    method transfer {amount targetAccount} {
        my variable total
        my withdraw $amount
        $targetAccount deposit $amount
        set total
    }
    method dump {} {
    }
    destructor {
        my variable total
        if {$total} {puts "remaining $total will be given to charity"}
    }
}
if 1 { # Hack to delay the copying until the first pass has scanned the object
    # Define that "my" within the definition is an object
    ##nagelfar copy _obj,Account oo::class\ create::Account::my
}

set a [Account new "John Doe"]
$a deposit 200
$a deposit 20
$a withdraw 150
$a withdraw 100
$a dump
set b [Account new]
$a transfer 65 $b
$a dump
$b dump
$a transfer 1000000 $b
$b destroy


# Define the class command

##nagelfar copy _stdclass c
##nagelfar syntax c\ create dc=_obj,c x?
##nagelfar return c\ create _obj,c
##nagelfar return c\ new _obj,c

# Define the object command

##nagelfar syntax _obj,c s x*
##nagelfar subcmd+ _obj,c bar foo Foo lollipop

oo::class create c
c create o
oo::define c method foo {} {
    puts "world"
}
oo::objdefine o {
    method bar {} {
        my Foo "hello "
        my foo
    }
    forward Foo ::puts -nonewline
    unexport foo
}
o bar
o foo
o Foo Bar
oo::objdefine o renamemethod bar lollipop
o lollipop

# Example with implicit variable:
##nagelfar copy _stdclass foo
##nagelfar syntax foo\ create dc=_obj,foo x?
##nagelfar return foo\ create _obj,foo
##nagelfar return foo\ new _obj,foo
##nagelfar implicitvar oo::class\ create::foo x
##nagelfar subcmd+ _obj,foo boo
oo::class create foo {
    variable x
    constructor y {
        set x $y
    }
    method boo z {
        list $x $z
    }
}
foo create bar quolf
bar boo x
