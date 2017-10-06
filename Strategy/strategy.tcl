
package require TclOO

################################################################################
# Different algorithms which can be used interchangeably                       #
# Strategy lets the algorithm vary independently from the clients that use it. #
################################################################################
oo::class create Strategy1 {
    constructor {} {
        puts "Strategy 1"
    }

    method doSomething {} {
        puts "doSomething according to the strategy 1"
    }
}

oo::class create Strategy2 {
    constructor {} {
        puts "Strategy 2"
    }

    method doSomething {} {
        puts "doSomething according to the strategy 2"
    }
}

oo::class create Client {
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


set strategy [Strategy2 new]
set myApp [Client new $strategy]
$myApp action