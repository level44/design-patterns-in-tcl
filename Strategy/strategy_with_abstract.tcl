
package require TclOO

################################################################################
# Different algorithms which can be used interchangeably                       #
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

#implementation abstract class strategy
class create Strategy {
    method doSomething {} abstract
}

#implementation of concrete strategy
class create Strategy1 {
    superclass Strategy
    constructor {} {
        puts "Strategy 1"
    }

    method doSomething {} {
        puts "doSomething according to the strategy 1"
    }
}

#implementation of concrete strategy
class create Strategy2 {
    superclass Strategy
    constructor {} {
        puts "Strategy 2"
    }

    method doSomething {} {
        puts "doSomething according to the strategy 2"
    }
}

#implementation without required doSomething method only to show that abstract method works
class create Strategy3 {
    superclass Strategy
    constructor {} {
        puts "Defined only to show that abstract class works"
    }
}

class create Client {
    variable strategy

    constructor s {
        set strategy $s
    }

    method action {} {
        $strategy doSomething
    }
}

#initialize app with strategy1
set strategy [Strategy1 new]
set myApp [Client new $strategy]
$myApp action
$myApp destroy

set strategy [Strategy2 new]
set myApp [Client new $strategy]
$myApp action
$myApp destroy

#uncomment to test if abstract class works
# set strategy [Strategy3 new]
# set myApp [Client new $strategy]
# $myApp action
# $myApp destroy
