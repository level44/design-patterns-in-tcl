console show
package require TclOO

################################################################################
# Notify all registered objects about changes                                  #
# Strategy lets the algorithm vary independently from the clients that use it. #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

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