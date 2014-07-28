\name{RcppProgress-package}
\alias{RcppProgress-package}
\alias{RcppProgress}
\docType{package}
\title{
  An interruptible progress bar with OpenMP support for c++ in R packages
}
\description{
This package allows to display a progress bar in the R
    console for long running computations taking place in c++ code,
    and provides support for interrupting those computations even in a multithreaded code.
}

\details{

When implementing CPU intensive computations in C++ in R packages, it is natural to want to monitor
the progress of those computations, and to be able to interrupt them, even when using
multithreading for example with OpenMP.
Another feature is that it can be done so that the code will still work even without OpenMP support.
This package offers some facilities to help implementing those features.
It it biased towards the use of OpenMP, but it should be compatible when using
multithreading in other ways.

\subsection{quick try}{
  There are two tests functions provided by the package to get a quick overview
  of what can be done.

  These tests are:

\describe{
\item{ RcppProgress:::test_sequential(max, nb, display_progress) }{ - a sequential code, i.e. single threaded }
\item{ RcppProgress:::test_multithreaded(max, nb, threads, display_progress) }{ - a multithreaded code using OpenMP}
}

Both tests call the very same function that implements a long computation.
The \bold{max} parameter controls the number of computations, and \bold{nb} controls the duration of a single computation,
that is quadratic in \bold{nb}.
The \bold{threads} is as expected the number of threads to use for the computation.
The \bold{progress} parameter toggles the display of the progress bar.

On my platform,
\preformatted{
system.time( RcppProgress:::test_multithreaded(100, 3000, 4) )
}
is a good start.

}

\subsection{c++ usage}{

There are usually two locations in the c++ code that needs to be modified.
The first one is the main loop, typically on the number of jobs or tasks. This loop is a good candidate to
be parallelized using OpenMP.
I will comment the code corresponding to the tests included with the package.


\preformatted{
void test_multithreaded_omp(int max, int nb, int threads
                              , bool display\_progress) \{

\#ifdef _OPENMP
    if ( threads > 0 )
        omp_set_num_threads( threads );
    REprintf(\"Number of threads=\%i\n\", omp_get_max_threads());
\#endif

    Progress p(max, display_progress); // create the progress monitor
#pragma omp parallel for schedule(dynamic)
    for (int i = 0; i < max; ++i) \{
        if ( ! p.is_aborted() ) \{ // the only way to exit an OpenMP loop
            long_computation(nb);
            p.increment(); // update the progress
        \}
    \}
\}
}

Here we create a Progress object with the number of tasks to perform, then
before performing a task we test for abortion (\code{p.is_aborted()}), because we can not exit an
OpenMP loop the usual way, suing a break for example, then
when after the computation, we increment the progress monitor.

Then let us look at the computation function (that is completely useless) :

\preformatted{
void long_computation(int nb) \{
    double sum = 0;
    for (int i = 0; i < nb; ++i) \{
      if ( Progress::check_abort() ) // check for user abort
        return;
      for (int j = 0; j < nb; ++j) \{
        sum += Rf_dlnorm(i+j, 0.0, 1.0, 0);
      \}
    \}
  \}
\}
}

Here the only interesting line is the  \code{Progress::check_abort()} call.
If called from the master thread, it will check for user interruption, and if needed
set the abort status code.
When called from another thread it will just check the status.
So all the art is to decide where to put his call: it should not be called not too often
or not frequently enough.
As a rule of thumb it should be called roughly evevry second.

}

\subsection{Using RcppProgress in your package}{

Please note that we provide the \bold{RcppProgressExample} example package along with this package, 
	located in the \code{examples} directory of the installed package.

Here are the steps to use RcppProgress in a new package:

\describe{

\item{ skeleton }{
create a package skeleton using Rcpp
\preformatted{

library(Rcpp)
Rcpp.package.skeleton( "RcppProgressExample" )}
}

\item{ DESCRIPTION }{ edit the \bold{DESCRIPTION} file  and add RcppProgress to 
the \strong{Depends:} and \strong{LinkingTo:} lines. e.g.
\preformatted{
Depends: Rcpp (>= 0.9.4), RcppProgress (>= 0.1)
LinkingTo: Rcpp, RcppProgress
}
 }

\item{ MakeVars }{ edit \bold{src/MakeVars} and replace its content by

PKG_LIBS = `$(R_HOME)/bin/Rscript -e "Rcpp:::LdFlags()"` $(SHLIB_OPENMP_CXXFLAGS) `$(R_HOME)/bin/Rscript -e "RcppProgress:::CxxFlags()"`
and

PKG_CXXFLAGS +=-Ilibsrc $(SHLIB_OPENMP_CXXFLAGS) `$(R_HOME)/bin/Rscript -e "RcppProgress:::CxxFlags()"`

}

\item{ c++ code }{
Put your code in \bold{src}.
You may for instance copy the RcppExample/src/tests.cpp file in \bold{src}, and  RcppExample/R/tests.R in
\bold{R}, and try to
compile the package (\code{R CMD INSTALL -l test .}) and execute the tests:

\preformatted{
%R
>library(RcppProgressExample, lib.loc="test")
>RcppProgressExample::test_multithreaded(100, 600, 4)
}
}

}
} % subsection
} % details


\seealso{
\describe{

\item{ OpenMP }{API specification for parallel programming: \url{http://openmp.org} }

\item{ Rcpp }{\url{http://r-forge.r-project.org/projects/rcpp}}
}

}

\author{
  Karl Forner

  Maintainer: Karl Forner <karl.forner@quartzbio.com>
}

\keyword{ package }

