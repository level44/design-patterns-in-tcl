console show
package require TclOO

################################################################################
# Notify all registered objects about changes                                  #
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

class create Subject {
    variable state
    variable observers

    constructor {} {
        set state 0
        set observers [list]
    }

    method attach {o} {
        lappend observers $o
    }

    method detach {o} {
        set observers [lreplace $observers [lsearch $observers $o] [lsearch $observers $o]]
    }

    method notify {} {
        foreach observer $observers {
            $observer update $state
        }
    }

    method update_state {s} {
        set state $s
        [self] notify
    }
}

class create Observer {
    variable observer_state

    constructor {} {
        set observer_state 0
    }

    method update {s} abstract
}

class create ConcreteObserver1 {
    superclass Observer
    variable observer_state

    method update {s} {
        set observer_state $s
        puts "C1 updated to $observer_state"
    }
}

class create ConcreteObserver2 {
    superclass Observer
    variable observer_state

    method update {s} {
        set observer_state $s
        puts "C2 updated to $observer_state"
    }
}

set c1 [ConcreteObserver1 new]
set c2 [ConcreteObserver2 new]

set s [Subject new]
$s attach $c1
$s attach $c2

$s update_state 3
$s update_state 5

$s detach $c1

$s update_state 6