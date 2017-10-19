console show
package require TclOO

################################################################################
# Extend method functionality without changing method                          #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

oo::class create TestMethod {

	method someBasicMethod {a b} {
		return [expr $a + $b]
	}

	#decorator
	method exampleDecorator {args} {
		set res [next {*}$args]
		if {$res < 0} {
			return 0
		} elseif {$res > 10} {
			return 10
		} else {
			return $res
		}
	}

	filter exampleDecorator
}

set n [TestMethod new]
puts [$n someBasicMethod 1 2]
puts [$n someBasicMethod -10 2]
puts [$n someBasicMethod 1 20]