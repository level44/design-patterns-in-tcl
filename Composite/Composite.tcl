console show
package require TclOO

################################################################################
# Compose objects into tree structures to represent part-whole hierarchies.    #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

class create Component {
    method doSomething {} abstract
}

class create Composite {
    superclass Component

    variable _children

    constructor {} {
        set _children []
    }

    method doSomething {} {
        #foreach child doSomething
        foreach child $_children {
            $child doSomething
        }
    }

    method add {component} {
        lappend _children $component
    }

    method remove {component} {
         set _children [lreplace $_children [lsearch $_children $component] [lsearch $_children $component]]
    }
}

class create Leaf {
    superclass Component

    variable _name

    constructor {name} {
        set _name $name
    }

    method doSomething {} {
        puts "doSomething for [self] $_name"
    }
}

set leaf1 [Leaf new "Leaf1"]
set leaf2 [Leaf new "Leaf2"]
set leaf3 [Leaf new "Leaf3"]
set composite1 [Composite new]
set composite2 [Composite new]

#simulate following structure
#-composite1
#  -leaf1
#  -composite2
#    -leaf2
#    -leaf3
$composite1 add $leaf1
$composite2 add $leaf2
$composite2 add $leaf3
$composite1 add $composite2
puts "Call doSomething for full structure"
$composite1 doSomething

#remove leaf3 and call doSomething again
$composite2 remove $leaf3
puts "Call doSomething for structure without leaf3"
$composite1 doSomething

#remove composite2 and coll doSomething again
$composite1 remove $composite2
puts "Call doSomething for structure without composite2"
$composite1 doSomething