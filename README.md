

# RcppProgress

<!-- badges: start -->
[![R-CMD-check](https://github.com/kforner/rcpp_progress/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kforner/rcpp_progress/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/kforner/rcpp_progress/branch/main/graph/badge.svg)](https://app.codecov.io/gh/kforner/rcpp_progress?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/RcppProgress)](https://cran.r-project.org/package=RcppProgress)
<!-- badges: end -->




a R package that provides a c++ interruptible progress bar with OpenMP support for c++ code in R packages:

- check for user interrupts in your c++ code
- display a progress bar monitoring your c++ computation
- compatible with multi-threaded c++ code (e.g. openMP)

## Installing

- from CRAN: `install.packages("RcppProgress")`
- from github: `remotes::install_github('kforner/rcpp_progress')`

## example
see a detailed example on Rcpp Gallery:
http://gallery.rcpp.org/articles/using-rcppprogress/

## How to build

Prerequisites:

- OpenMP support to use the multithreaded parallelized version. OpenMP is available in GCC >= 4.2

Just install it the usual way.

If you want more control, unarchive it, cd to the source directory, then type
R CMD INSTALL . in the console.

## Feedback

Please use github issues to provide feedback, report bugs and propose new features.

## Contribute

Contributions are welcome!
The proposed process is:

- open an issue and propose your changes
- fork the project
- do a merge request
- code review
- merge into master

New code must be tested and documented, and also come with an example.


## For developers

### tests and check

If you have all the RcppProgress dependencies (and suggests) installed:

type:
 - `make tests`: to run the tests
 - `make check`: to check the package

### docker-checker

A Dockerfile (<docker_checker/Dockerfile>) is provided to help building the
dev environment (built on rocker/r-devel) in which to develop
and test RcppProgress.

type:

 - `make docker/build`: to build the docker
 - `make docker/run`: to run a shell in the docker with the current dir mounted
 	inside
 - `make docker/check`: to check the package inside the docker
 - `make docker/tests`: to run test tests of the package inside the docker

### test on windows using rhub

```
make docker/run
make check_rhub_windows
```


