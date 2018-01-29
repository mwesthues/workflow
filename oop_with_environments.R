# Source: https://rstudio-pubs-static.s3.amazonaws.com/150296_904158e070594471864e89c10c0d14f9.html
# we can create environments
MyEnv <- new.env()

# ...and assign values to their variables...
MyEnv$a <- 5
MyEnv$b <- TRUE

# ...and retrieve them, just like with lists...
MyEnv$a

#... and even loop through them easily
for (el in ls(MyEnv)) {
  print(MyEnv[[el]])
}

# we can try to copy an environment
MyEnv_copy <- MyEnv

# ... but it will just create another pointer
MyEnv$a <- 10
MyEnv_copy$a

# you also can't use == to compare, but need the identical function
identical(MyEnv_copy, MyEnv)

##
# Just like we did before with lists, we can also set the class attribute
# of environments. So we get an easy way to create objects that behave like we
# know it from other languages by simply returning a pointer to the environment
# of a function from it. We do this by using the 'environment' function to get
# this pointer to the current environment inside the constructor function.

# with environments we get classes...
MyClass <- function(x) {
  x <- x - 1
  get_x <- function() x
  structure(class = "MyClass", environment())
}

#... that are truly classy
MyObject <- MyClass(3)
MyObject$x

MyObject$x <- 5
MyObject$get_x()
