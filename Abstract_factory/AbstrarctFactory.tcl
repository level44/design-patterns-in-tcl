console show
package require TclOO

################################################################################
# Provide an interface for creating families of related or dependent           #
# objects without specifying their concrete classes.                           #
# Strategy lets the algorithm vary independently from the clients that use it. #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

class create AbstractFactory {

    method create_product_a {} abstract

    method create_product_b {} abstract
}

class create ConcreteFactory1 {

    method create_product_a {} {
        return [ProductA1 new]
    }

    method create_product_b {} {
        return [ProductB1 new]
    }
}

class create ConcreteFactory2 {

    method create_product_a {} {
        return [ProductA2 new]
    }

    method create_product_b {} {
        return [ProductB2 new]
    }
}

class create Product {
    method interface {} abstract
}

class create ProductA1 {
    method interface {} {
        puts "Interface called for [info object class [self]]"
    }
}

class create ProductB1 {
    method interface {} {
        puts "Interface called for [info object class [self]]"
    }
}

class create ProductA2 {
    method interface {} {
        puts "Interface called for [info object class [self]]"
    }
}

class create ProductB2 {
    method interface {} {
        puts "Interface called for [info object class [self]]"
    }
}

set Factory1 [ConcreteFactory1 new]
set Factory2 [ConcreteFactory2 new]

set someProduct1 [$Factory1 create_product_a]
set someProduct2 [$Factory2 create_product_a]

$someProduct1 interface
$someProduct2 interface
