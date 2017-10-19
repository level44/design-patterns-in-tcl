console show
package require TclOO

################################################################################
# Different algorithms which can be used interchangeably                       #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

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
