
library(dplyr)
library(assertive)


hypotenus <- function(x, y){
    x <- x %>%
        assert_is_a_double()

    y <- y %>%
        assert_is_a_double()

    return( sqrt( x^2 + y^2 ) )
}
