
package require TclOO
console show
################################################################################
# More than one object has chance to handle request.                           #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

#Implemantation of class used to create abstract methods - ref to wiki article
oo::class create ::class {
    superclass oo::class
    self method create {name args} {
        set instance [next $name {*}$args]
        oo::define $instance superclass -append [self]
        return $instance
    }
    method new args {
        my <VERIFY.CONCRETE>
        next {*}$args
    }
    method create {name args} {
        my <VERIFY.CONCRETE>
        next $name {*}$args
    }

    method <VERIFY.CONCRETE> {} {
        foreach m [info class methods [self] -all] {
            set call [lindex [info class call [self] $m] 0]
            if {[lindex $call 0] eq "method" && [lindex $call 3] eq "method"} {
                set cls [lindex $call 2]
                set body [lindex [info class definition $cls $m] 1]
                if {$body eq "abstract"} {
                    return -code error -level 2 \
                        -errorcode {CLASS ABSTRACTMETHOD} \
                        "[self] is abstract (method \"$m\")"
                }
            }
        }
    }
}

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
            puts "handler 1 - possible"
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