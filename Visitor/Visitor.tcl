console show
package require TclOO

################################################################################
# Different algorithms which can be used interchangeably                       #
# Strategy lets the algorithm vary independently from the clients that use it. #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

class create Element {
    method accept {visitor} abstract
}

class create ConcreteElement1 {
    method accept {visitor} {
        $visitor accepted [self]
    }
}

class create ConcreteElement2 {
    method accept {visitor} {
        $visitor accepted [self]
    }
}

class create Visitor {
    method accepted {o} abstract
}

class create ConcreteVisitor {
    method accepted {o} {
        puts "ConcreteVisitor: accepted by $o"
    }
}

set Element1 [ConcreteElement1 new]
set Element2 [ConcreteElement2 new]
set Visitor1 [ConcreteVisitor new]

$Element1 accept $Visitor1
$Element2 accept $Visitor1