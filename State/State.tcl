console show
package require TclOO

################################################################################
# Object state as a class - an object oriented state machine                   #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

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