# RcppProgress
[![Build Status](https://travis-ci.org/kforner/rcpp_progress.svg?branch=master)](https://travis-ci.org/kforner/rcpp_progress)
[![codecov](https://codecov.io/github/kforner/rcpp_progress/coverage.svg)](https://codecov.io/github/kforner/rcpp_progress)


a R package that provides a c++ interruptible progress bar with OpenMP support for c++ code in R packages

## example
see a detailed example on Rcpp Gallery:
http://gallery.rcpp.org/articles/using-rcppprogress/

## How to build

Prerequisites:

- OpenMP support to use the multithreaded parallelized version. OpenMP is available in GCC >= 4.2

Just install it the usual way.

If you want more control, unarchive it, cd to the source directory, then type
R CMD INSTALL . in the console.


## Contribute
Send me a pull request with at least one test or example


