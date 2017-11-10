console show
package require TclOO

################################################################################
# Separate the construction of a complex object from its representation so     #
# that the same construction process can create different representations.     #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

class create Director {
    variable _builder

    constructor {builder} {
        set _builder $builder
    }

    method buildProduct {} {
        $_builder buildWheels
        $_builder buildBody
        $_builder buildEngine
    }
}

class create Builder {
    variable Product

    constructor {} {
        set Product [Product new]
    }

    method buildWheels {} abstract
    method buildBody {} abstract
    method buildEngine {} abstract
}

class create ConcreteBuilder {
    superclass Builder
    variable Product

    # constructor {args} {
    #     next {*}$args
    # }

    method buildWheels {} {
        puts "Building wheels"
        $Product wheels 4
    }

    method buildBody {} {
        puts "Building body"
        $Product body sedan
    }

    method buildEngine {} {
        puts "Building engine"
        $Product engine "v6"
    }

    method product {} {
        return $Product
    }
}

class create Product {
    variable _wheels
    variable _body
    variable _engine

    constructor {} {
        set _wheels -1
        set _body -1
        set _engine -1
    }

    method wheels {wheels} {
        set _wheels $wheels
    }

    method body {body} {
        set _body $body
    }

    method engine {engine} {
        set _engine $engine
    }

    method specification {} {
        return [dict create wheels $_wheels body $_body engine $_engine]
    }
}

set builder [ConcreteBuilder new]
set director [Director new $builder]
$director buildProduct
set product [$builder product]
puts [$product specification]