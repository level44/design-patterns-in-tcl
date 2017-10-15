console show
package require TclOO

################################################################################
# More than one object has chance to handle request.                           #
# Handlers does not know about each other.                                     #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

class create handler {
    method handle {} abstract
}

class create concreteHandler1 {
    superclass handler

    method handle {} {
        if {0} {
            puts "handler 1 - possible"
            return 0
        } else {
            puts "handler 1 - not possible"
            return -1
        }
    }
}

class create concreteHandler2 {
    superclass handler

    method handle {} {
        if {1} {
            puts "handler 2 - possible"
            return 0
        } else {
            puts "handler 2 - not possible"
            return -1
        }
    }
}

class create requestHandler {
    variable handlers

    constructor {} {
        set handler [list]
    }

    method registerHandler {handler} {
        lappend handlers $handler
    }

    method handle {} {
        foreach handler $handlers {
            if {[set resp [$handler handle]] >= 0} {
                return $resp
            }
        }
        return -1
    }
}

set cHandler1 [concreteHandler1 new]
set cHandler2 [concreteHandler2 new]

set rHandler [requestHandler new]
$rHandler registerHandler $cHandler1
$rHandler registerHandler $cHandler2

puts [$rHandler handle]