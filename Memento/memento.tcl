package require TclOO

################################################################################
# Store internal object state and restore on request.                          #
################################################################################
oo::class create Persistence {
    variable pers

    method initialize {} {
        array set pers []
    }

    method store {obj} {
        foreach v [info object vars $obj] {
            set pers($v) [set [set obj]::$v]
        }
    }

    method restore {obj} {
        foreach var [array names pers] {
            set [set obj]::$var $pers($var)
        }
    }
}

oo::class create Originator {
    mixin Persistence

    variable var1
    variable var2

    constructor {} {
        set var1 0
        set var2 0
    }

    method updateVars {v1 v2} {
        set var1 $v1
        set var2 $v2
    }

    method printVars {} {
        puts "var1: $var1 var2: $var2"
    }

    method dumpState {} {
        my store [self]
    }

    method restoreState {} {
        my restore [self]
    }
}

set obj [Originator new]
$obj printVars
$obj dumpState
$obj updateVars 10 200
$obj printVars
$obj restoreState
$obj printVars