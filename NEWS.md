# RcppProgress 0.4.2

- the constructor now clears out any existing Progress instance. That fixes some problems with recent
  versions of R that seem able sometimes to intercept the interrupt at the R level, 
  cf https://github.com/kforner/rcpp_progress/issues/4


# RcppProgress 0.4

  - RccpProgress now can use custom Progress Bars (draft by Clemens Schmid @nevrome)
    The include example package RcppProgressETA, included in RcppProgress is an
    example of using such a custom progress bar, and also contains an implementation
    (by Clemens Schmid @nevrome) of a vertical progress bar that displays the ETA
    (Estimated Time of completion).


  - reorganized the example tests functions: they are no longer implemented inside
    RcppProgress code, but called from the embedded RcppProgressExample example
    package. As a result RcppProgress no longer provides a dynamic library, nor
    does need to link against Rcpp. The example tests are also now available as
    testthat tests, thus used during the package check.

  - cleaned the Dockerfile and improved the docker-related Makefile targets

  - refactored the Makefile



# RcppProgress 0.3

* fixed issue #3: The Rcpp namespace is no longer open

* fixed issue #2 about extra progress bar symbols being printed

* refactored code by putting display code in class ProgressBar

* fixed armadillo example warning.


# RcppProgress 0.2

* improvement by Jacques-Henri Jourdan to make it possible to use the progress monitor in multiple cpp files.

* fixed compatibility problems with RcppArmadillo header.

* provided a new example of using RcppArmadillo

* used Rf_error instead of error in the implementation

* add a note in the doc about RcppArmadillo

* added this file


