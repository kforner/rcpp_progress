# RcppProgress 1.0.0

- fixed issue #38: Progress::check_abort() crashes in no Progress instance has been created
- added back and exported the test functions, allowing to easily test the included example packages
  (cf http://kforner.github.io/rcpp_progress/reference/test_multithreaded.html for instance)
- modernized the github repository
    * now using vscode **devcontainer**
    * using **pkgdown** and deploying doc to http://kforner.github.io/rcpp_progress/
    * configured test coverage reporting using *codecov**
    * now using roxygen2
    * added CI github actions to test the package on multiple architectures and OSes 
      (except on Macos for now), report the test coverage and deploy the documentation
- refreshed the documentation, the README, added vignette from the RcppGallery, and added a short
    vignette for RcppArmadillo

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


