console show
package require TclOO

################################################################################
# Define representation for some grammar                                       #
# Strategy lets the algorithm vary independently from the clients that use it. #
# This example uses abstract method implemented according to the wiki article: #
# https://wiki.tcl.tk/40639                                                    #
################################################################################

source {../AbstractClassHelper.tcl}

class create Interpreter {
    variable data

    constructor {d} {
        set data $d
    }

    method interpret {m} abstract
}

class create ConcreteInterpreter {
    method interpret {m o} {
        if {[regexp {book\s([0-9])\sget\s(title|author|content)} $m match bookNumber bookCommand]} {
            switch $bookCommand {
                "title" {
                    return [$o getTitle $bookNumber]
                }
                "author" {
                    return [$o getAuthor $bookNumber]
                }
                "content" {
                    return [$o getContent $bookNumber]
                }
            }
        } else {
            return "Wrong command"
        }
    }
}

class create Book {
    variable _author
    variable _title
    variable _content

    constructor {author title content} {
        set _author $author
        set _title $title
        set _content $content
    }

    method getAuthor {} {
        return $_author
    }

    method getTitle {} {
        return $_title
    }

    method getContent {} {
        return $_content
    }
}

class create Books {
    variable books

    constructor {} {
        set books [list]
    }

    method addBook {author title content} {
        lappend books [Book new $author $title $content]
    }

    method getAuthor {bookNumber} {
        return [[lindex $books [expr $bookNumber - 1]] getAuthor]
    }

    method getTitle {bookNumber} {
        return [[lindex $books [expr $bookNumber - 1]] getTitle]
    }

    method getContent {bookNumber} {
        return [[lindex $books [expr $bookNumber - 1]] getContent]
    }

    #filtering wrong requests
    method checkLimit {args} {
        set method [lindex [self target] end]
        if {$method in [list getAuthor getTitle getContent]} {
            if {[string is digit $args]} {
                if {$args > [llength $books]} { return "Wrong book number" }
            } else { return "Wrong book number" }
        }
        next {*}$args
    }
    filter checkLimit
}

set library [Books new]
$library addBook "Edgard Nowak" "PHP for dummies" "Chapter 1 tbd"
$library addBook  "Marian Kowalski" "jQuery for dummies" "Chapter 1 tbd"

set c [ConcreteInterpreter new]
puts [$c interpret "book 1 get title" $library]
puts [$c interpret "book 1 get author" $library]
puts [$c interpret "book 2 get title" $library]
puts [$c interpret "book 2 get author" $library]
#index out of range
puts [$c interpret "book 3 get author" $library]
#wrong command
puts [$c interpret "books 3 get author" $library]
