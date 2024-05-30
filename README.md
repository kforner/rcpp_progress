

RcppProgress
==============

<!-- badges: start -->
[![R-CMD-check](https://github.com/kforner/rcpp_progress/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kforner/rcpp_progress/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/kforner/rcpp_progress/branch/master/graph/badge.svg)](https://app.codecov.io/gh/kforner/rcpp_progress?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/RcppProgress)](https://cran.r-project.org/package=RcppProgress)
<!-- badges: end -->

a R package that provides a C++ interruptible progress bar with **OpenMP** support for C++ code in R packages:

- can check for user interrupts in your C++ code
- can display a progress bar monitoring your C++ computation
- is compatible with multi-threaded C++ code (e.g. [openMP](https://www.openmp.org/))

## Overview

Usually you write C++ code with R when you want to speedup some calculations.
Depending on the parameters, and especially during the development, it is
difficult to anticipate the execution time of your computation, so that you
do not know if you have to wait for one minute or several hours.

RcppProgress is a tool to help you monitor the execution time of your C++ code, by
providing a way to **interrupt** the execution inside the C++ code, and also to
display a **progress bar** indicative of the state of your computation.

Additionally, it is compatible with multithreaded code, for example using
**OpenMP**, which is not as trivial as it may seem since you cannot just stop the
execution in one thread. Also, not all threads should be writing in the console
to avoid garbled output.


## Installing

- from CRAN: `install.packages("RcppProgress")`
- from github: `remotes::install_github('kforner/rcpp_progress')`

## Quick try

There are test functions included in `RcppProgress` for convenience, that let you run some R functions calling C++ 
code,  interruptible (by typing `CTRL+c`) and displaying a progress bar: 

- `test_multithreaded()`
- `test_amardillo_multithreaded()`
- `test_eta_progress_bar()`

These functions use the example R packages included in the `RcppProgress` package 
(check the `inst/examples` in the github repository).

For example:
```
>RcppProgress::test_multithreaded()
Number of threads=4
0%   10   20   30   40   50   60   70   80   90   100%
[----|----|----|----|----|----|----|----|----|----|
**************************************************|
```

## Inline demo

You can also test a complete example entirely in your R console!

```r
# our C++ code
CODE <- r"(
#ifdef _OPENMP
#include <omp.h>
#endif
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::depends(RcppProgress)]]
#include <progress.hpp>
#include <progress_bar.hpp>

// [[Rcpp::export]]
double long_computation_omp_progress(int nb, int threads=1) {
#ifdef _OPENMP
    if ( threads > 0 )
        omp_set_num_threads( threads );
#endif
    Progress p(nb, true);
    double sum = 0;
#pragma omp parallel for schedule(dynamic)   
    for (int i = 0; i < nb; ++i) {
        double thread_sum = 0;
        if ( ! Progress::check_abort() ) {
            p.increment(); // update progress
            for (int j = 0; j < nb; ++j) {
                thread_sum += R::dlnorm(i+j, 0.0, 1.0, 0);
            }
        }
        sum += thread_sum;
    }
  
    return sum + nb;
}
)"

# compile and run it
Rcpp::sourceCpp(code = CODE)
res <- long_computation_omp_progress(10000, 4)

```

## example

There is a detailed example on Rcpp Gallery: http://gallery.rcpp.org/articles/using-rcppprogress/.
It has been improved an is now available as a vignette 
TODO: insert link

## Feedback

Please use github issues to provide feedback, report bugs and propose new features.

## Development

cf [here](dev.md)