console show
package require TclOO

################################################################################
# More than one object has chance to handle request.                           #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

class create handler {
    variable _successor

    constructor {{successor -1}} {
        set _successor $successor
    }

    method handle {} abstract
}

class create concreteHandler1 {
    superclass handler
    variable _sucessor

    method handle {} {
        if {1} {
            puts "handler 1 - possible"
            #object can handle this request
        } else {
            puts "handler 1 - not possible"
            $_successor handle
        }
    }
}

class create concreteHandler2 {
    superclass handler
    variable _successor

    method handle {} {
        if {0} {
            puts "handler 2 - possible"
            #object cannot handle this request
        } else {
            puts "handler 2 - not possible"
            $_successor handle
        }
    }
}

set cHandler1 [concreteHandler1 new]
set cHandler2 [concreteHandler2 new $cHandler1]

$cHandler2 handle