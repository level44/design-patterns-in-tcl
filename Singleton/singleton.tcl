package require oo::util

################################################################################
# Only one instance of this kind of object possible. #
################################################################################
ooutil::singleton create logger {
	constructor {} {
		puts "Singleton example"
	}

	method log {str} {
		puts $str
	}
}

set obj1 [logger new]
set obj2 [logger new]
puts "obj1 handler: $obj1\,obj2 handler: $obj2 "

puts [info class instances logger]