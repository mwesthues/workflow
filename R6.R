# Source: https://cran.r-project.org/web/packages/R6/vignettes/Introduction.html
library("R6")

# Create a simple R6 class. The 'public' argument is a list of items, which can
# be functions and fields (non-functions). Functions will be used as methods.
Person <- R6Class(
  classname = "Person",
  public = list(
    name = NULL,
    hair = NULL,
    initialize = function(name = NA, hair = NA) {
      self$name <- name
      self$hair <- hair
      self$greet()
    },
    set_hair = function(val) {
      self$hair <- val
    },
    greet = function() {
      cat(paste0("Hello, my name is ", self$name, ".\n"))
    }
  )
)

# To instantiate an object of this class, use '$new()':
ann <- Person$new(name = "Ann", hair = "black")
ann

# The '$new()' method creates the object and calls the 'initialize()' method,
# if it exists.
# Inside methods of the class, 'self' refers to the object. Public members of
# the object (all you've seen so far) are accessed with 'self$x', and assignment
# is done with 'self$x <- y'.
# Note that by default, 'self' is required to access members, although for
# non-portable classes, which we'll see later, it is optional.

# Once the object is instantiated, you can access values and methods with '$':
ann$hair
ann$greet()
ann$set_hair("red")
ann$hair

# Implementation note: The external face of an R6 object is basically an
# environment with the public members in it. This is also known as the 'public
# environment'. An R6 object's methods have a separate 'enclosing environment'
# which, roughly speaking, is the environment they "run in". This is where
# 'self' binding is found, and it is simply a reference back to the public
# environment.

## -- PRIVATE MEMBERS ------------------------------------------------------
# In the previous example, all the members were public. It's also possible to
# add private members:
Queue <- R6Class(
  classname = "Queue",
  public = list(
    initialize = function(...) {
      for (item in list(...)) {
        self$add(item)
      }
    },
    add = function(x) {
      private$queue <- c(private$queue, list(x))
      invisible(self)
    },
    remove = function() {
      if (private$length() == 0) return(NULL)
      # can use private$queue for explicit access
      head <- private$queue[[1]]
      private$queue <- private$queue[-1]
      head
    }
  ),
  private = list(
    queue = list(),
    length = function() base::length(private$queue)
  )
)

q <- Queue$new(5, 6, "foo")

# Whereas public members are accessed with 'self', like 'self$add()', private
# members are accessed with 'private', like 'private$queue'.

# The public members can be accessed as usual:
q$add("something")
q$add("another thing")
q$add(17)
q$remove()
q$remove()

# However, private members can't be accessed directly:
q$queue
q$length()

# A useful design pattern is for methods to return 'self' (invisibly) when
# possible, because it makes them chainable. For example, the 'add()' function
# returns 'self' so you can chain them together:
q$add(10)$add(11)$add(12)

# On the other hand, 'remove()' returns the value removed, so it's not chainable:
q$remove()
q$remove()
q$remove()
q$remove()


## -- ACTIVE BINDINGS --------------------------------------------------------
Numbers <- R6Class(
  classname = "Numbers",
  public = list(
    x = 100
  ),
  active = list(
    x2 = function(value) {
      if (missing(value)) return(self$x * 2)
      else self$x <- value / 2
    },
    rand = function() rnorm(1)
  )
)

n <- Numbers$new()
n$x

# When an active binding is accessed, as if reading a value, it calls the
# function with 'value' as a missing argument:
n$x2

# When it' accessed as if assigning a value, it uses the assignment value as
# the 'value' argument:
n$x2 <- 1000
n$x

# If the function takes no arguments, it's not possible to use it with '<-':
n$rand
n$rand
n$rand <- 3

# Implementation note: Active bindings are bound in the public environment. The
# enclosing environment for these functions is also the public environment.

## -- INHERITANC ------------------------------------------------------------