
package require TclOO

################################################################################
# Simplifing communication between objects                                     #
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

class create mediator {
    variable collegues

    constructor {} {
        array set collegues [list]
    }

    method addCollegue {name} abstract

    method removeCollegue {name} abstract

    method sendMsg {msg collegue} abstract
}

class create collegue {
    variable mediator

    constructor {m} {
        set mediator $m
    }

    method receive {msg} abstract
}

class create concreteMediator {
    superclass mediator
    variable collegues

    constructor {} {
        next
    }

    method addCollegue {name collegue} {
        set collegues($name) $collegue
    }

    method removeCollegue {$name} {
        unset -nocomplain collegues($name)
    }

    method sendMsg {msg collegue} {
        foreach name [array names collegues] {
            if {$collegue != $collegues($name)} {
                $collegues($name) receive $msg
            }
        }
    }
}

class create concreteCollegue1 {
    superclass collegue
    variable mediator

    method receive {msg} {
        puts "Received C1: $msg"
    }

    method send {msg} {
        $mediator sendMsg $msg [self]
    }
}

class create concreteCollegue2 {
    superclass collegue
    variable mediator

    method receive {msg} {
        puts "Received C2: $msg"
    }

    method send {msg} {
        $mediator sendMsg $msg [self]
    }
}

class create concreteCollegue3 {
    superclass collegue
    variable mediator

    method receive {msg} {
        puts "Received C3: $msg"
    }

    method send {msg} {
        $mediator sendMsg $msg [self]
    }
}


set m [concreteMediator new]
set c1 [concreteCollegue1 new $m]
set c2 [concreteCollegue2 new $m]
set c3 [concreteCollegue3 new $m]

$m addCollegue 'C1' $c1
$m addCollegue 'C2' $c2
$m addCollegue 'C3' $c3

$c1 send "Communication test from C1"
$c2 send "Communication test from C2"