console show
package require TclOO

oo::class create collection {
	variable data

	constructor {d} {
		set data $d
	}

	method create_iterator {} {
		return [iterator new [self]]
	}
}


oo::class create iterator {
	variable collection
	variable index

	constructor {c} {
		set index 0
		set collection $c
	}

	method next {} {
		if {$index == [llength [set [set collection]::data]]} {
			return -code error "OutOfList"
		}
		set ret [lindex [set [set collection]::data] $index]
		incr index
		return $ret
	}
}


set obj [collection new [list 1 2 3 4]]
set iter [$obj create_iterator]
while {[catch {set val [$iter next]}] != 1} {
	puts $val
}