console show
package require TclOO

################################################################################
# Object state as a class - an object oriented state machine                   #
# Strategy lets the algorithm vary independently from the clients that use it. #
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

class create Context {
    variable state


    constructor {s} {
        set state $s
    }

    method request {} {
        $state handle
    }

    method setState {s} {
        set state $s
    }
}

class create State {
    method handle {} abstract
}

class create ConcreteState1 {
    superclass State

    method handle {} {
        puts "C1 handle request"
    }
}

class create ConcreteState2 {
    superclass State

    method handle {} {
        puts "C2 handle request"
    }
}

set C1 [ConcreteState1 new]
set C2 [ConcreteState2 new]
set Context1 [Context new $C1]
$Context1 request
$Context1 setState $C2
$Context1 request