

RcppProgress
==============

<!-- badges: start -->
[![R-CMD-check](https://github.com/kforner/rcpp_progress/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kforner/rcpp_progress/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/kforner/rcpp_progress/branch/master/graph/badge.svg)](https://app.codecov.io/gh/kforner/rcpp_progress?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/RcppProgress)](https://cran.r-project.org/package=RcppProgress)
<!-- badges: end -->

a R package that provides a C++ interruptible progress bar with OpenMP support for C++ code in R packages:

- check for user interrupts in your C++ code
- display a progress bar monitoring your C++ computation
- compatible with multi-threaded C++ code (e.g. [openMP](https://www.openmp.org/))

## Overview

Usually you write C++ code with R when you want to speedup some calculations.
Depending on the parameters, and especially during the development, it is
difficult to anticipate the execution time of your computation, so that you
do not know if you have to wait for one minute or several hours.

RcppProgress is a tool to help you monitor the execution time of your C++ code, by
providing a way to interrupt the execution inside the C++ code, and also to
display a progress bar indicative of the state of your computation.

Additionally, it is compatible with multithreaded code, for example using
OpenMP, which is not as trivial as it may seem since you cannot just stop the
execution in one thread. Also, not all threads should be writing in the console
to avoid garbled output.


## Installing

- from CRAN: `install.packages("RcppProgress")`
- from github: `remotes::install_github('kforner/rcpp_progress')`

## Quick try

There are test functions included in `RcppProgress` that let you run some R functions calling C++ 
code interruptible (by typing `CTRL+c`) and displaying a progress bar: 

- `test_multithreaded()`
- `test_amardillo_multithreaded()`
- `test_eta_progress_bar()`

These functions use the example R packages, included in the `RcppProgress` package 
(check the `inst/examples` in the github repository).

For example:
```
>RcppProgress::test_multithreaded()
Number of threads=4
0%   10   20   30   40   50   60   70   80   90   100%
[----|----|----|----|----|----|----|----|----|----|
**************************************************|
```

## example

There is a detailed example on Rcpp Gallery: http://gallery.rcpp.org/articles/using-rcppprogress/.
It has been improved an is now available as a vignette 

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


