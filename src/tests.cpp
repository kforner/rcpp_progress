#include "progress.hpp"

#ifdef _OPENMP
#include <omp.h>
#endif

#include <Rmath.h>

// this an example of code for which to provide support for user interruption
void long_computation(int nb) {
	double sum = 0;
	for (int i = 0; i < nb; ++i) {
		if ( Progress::check_abort() ) // the only modification to the code
			return;
		for (int j = 0; j < nb; ++j) {
			sum += Rf_dlnorm(i+j, 0.0, 1.0, 0);
		}
	}
}

// sequential test, that displays optionally a progress bar
void test_sequential(int max, int nb, bool display_progress) {
	Progress p(max, display_progress);
	for (int i = 0; i < max; ++i) {
		if ( ! p.is_aborted() ) {
			long_computation(nb);
			p.increment();
		}
	}
}

// same, but multithreaded if OpenMP is available test, that displays optionally a progress bar
void test_multithreaded_omp(int max, int nb, int threads, bool display_progress) {

#ifdef _OPENMP
	if ( threads > 0 )
		omp_set_num_threads( threads );
	REprintf("Number of threads=%i\n", omp_get_max_threads());
#endif

	Progress p(max, display_progress); // create the progress monitor
#pragma omp parallel for schedule(dynamic)
	for (int i = 0; i < max; ++i) {
		if ( ! p.is_aborted() ) { // the only way to exit an OpenMP loop
			long_computation(nb);
			p.increment(); // update the progress
		}
	}
}

RcppExport SEXP test_sequential_wrapper(SEXP __max, SEXP __nb, SEXP __display_progress) {
	test_sequential(as<unsigned long>(__max), as<int>(__nb), as<bool>(__display_progress));
	return R_NilValue;
}

RcppExport SEXP test_multithreaded_wrapper(SEXP __max, SEXP __nb, SEXP __threads, SEXP __display_progress) {
	test_multithreaded_omp(as<unsigned long>(__max), as<int>(__nb), as<int>(__threads), as<bool>(__display_progress));
	return R_NilValue;
}
