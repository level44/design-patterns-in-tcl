console show
package require TclOO

################################################################################
# Decouple an abstraction from its implementation so that the two can vary     #
# independently                                                                #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

class create AbstractionInterface {
    variable _implementator

    constructor {implementator} {
        set _implementator $implementator
    }

    method doSomething {str} {
        $_implementator doSomething_implementation $str
    }
}

class create AbstractImplementator {

    method doSomething_implementation {str} abstract
}

class create Implementator {
    superclass AbstractImplementator

    method doSomething_implementation {str} {
        puts $str
    }
}


set implementator [Implementator new]
set interface [AbstractionInterface new $implementator]

$interface doSomething "test 123"