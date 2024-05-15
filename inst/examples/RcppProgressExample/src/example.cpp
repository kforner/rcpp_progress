#include "progress.hpp" // RcppProgress C++ stuff
#include <Rcpp.h>   // Rcpp stuff

#include <Rmath.h>  // for the example computation, that uses Rf_dlnorm()


using namespace Rcpp;

// your computationally intensive function that you want to execute in loops
double compute_something(int nb, int i) {
  double sum1 = 0;
  for (int j = 0; j < nb; ++j) {
    sum1 += Rf_dlnorm(i+j, 0.0, 1.0, 0);
  }
  return sum1;
}

// your function for which interruption support
double compute_more_and_check_interruption(int nb) {
  double sum2 = 0;
	for (int i = 0; i < nb; ++i) {
		if (Progress::check_abort()) return 0;// here's the explicit check for interruption
    sum2 += compute_something(nb, i);
	}
  return sum2;
}

// main function for RcppProgress use: setup the Progress bar
double test_sequential(int max, int nb, bool display_progress) {
	Progress p(max, display_progress); // create the Rcpp Progress bar
  double sum3 = 0;
	for (int i = 0; i < max; ++i) {
    // increment the progress bar (and also test for interruption)
    if (!p.increment()) break; 
	  sum3 += compute_more_and_check_interruption(nb);
	}

  // here's where you check if the computation was performed or aborted, and notify it
  // via a value of your choice, here -1 
  if (p.is_aborted()) return -1;

  return sum3;
}

double test_multithreaded_omp(int max, int nb, int threads, bool display_progress) {
  std::vector<double> res_by_task(max);
#ifdef _OPENMP
	if (threads > 0)
		omp_set_num_threads(threads);
	REprintf("Number of threads=%i\n", omp_get_max_threads());
#endif

	Progress p(max, display_progress); // create the progress monitor
#ifdef _OPENMP
#pragma omp parallel for schedule(dynamic)
#endif
	for (int i = 0; i < max; ++i) {
    // N.B: you can not exit an OpenMP loop with a `return` otherwise you get a:
    // "error: invalid exit from OpenMP structured block" error 
		if ( p.increment() ) { // the only way to exit an OpenMP loop
			res_by_task[i] = compute_more_and_check_interruption(nb);
		}
	}

  if (p.is_aborted()) return -1;

  double res = 0;
  for (int i = 0; i < max; ++i) res += res_by_task[i];
  return res;
}

// Rcpp wrapper for the test_sequential() example function
RcppExport SEXP test_sequential_wrapper(SEXP __max, SEXP __nb, SEXP __display_progress) {
	double res = test_sequential(as<unsigned long>(__max), as<int>(__nb), as<bool>(__display_progress));
  return wrap(res);
}

// Rcpp wrapper for the test_multithreaded_omp() example function
RcppExport SEXP test_multithreaded_wrapper(SEXP __max, SEXP __nb, SEXP __threads, SEXP __display_progress) {
	double res = test_multithreaded_omp(as<unsigned long>(__max), as<int>(__nb), as<int>(__threads), as<bool>(__display_progress));
	return wrap(res);
}
