
package require TclOO

################################################################################
# Request as object to log requests, expand API by unavailable methods         #
################################################################################
oo::class create Book {
	variable author
	variable title
	variable content

	constructor {a t} {
		set author $a
		set title $t
		set content "Not ready yet"
	}

	method getAuthor {} {
		return $author
	}

	method getTitle {} {
		return $title
	}

	method getContent {} {
		return $content
	}
}

oo::class create Command {
	variable receiver

	constructor {c} {
		set receiver $c
	}

	method execute {} {

	}
}

oo::class create BookAuthor {
	superclass Command
	variable receiver

	method execute {} {
		return [$receiver getAuthor]
	}
}

oo::class create BookTitle {
	superclass Command
	variable receiver

	method execute {} {
		return [$receiver getTitle]
	}
}

oo::class create BookSummary {
	superclass Command
	variable receiver

	method execute {} {
		set resp "Author: [$receiver getAuthor]\n"
		append resp "Title: [$receiver getTitle]\n"
		append resp "Content: [$receiver getContent]\n"
		return $resp
	}
}

set book1 [Book new "Anonymous Writer" "Design Patterns"]
set command1 [BookAuthor new $book1]
set command2 [BookTitle new $book1]
set command3 [BookSummary new $book1]
puts [$command1 execute]
puts [$command2 execute]
puts "Summary:"
puts [$command3 execute]