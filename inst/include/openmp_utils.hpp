/*
 * OPENMP related utilities
 */
#ifndef _RcppProgress_OPENMP_HPP
#define _RcppProgress_OPENMP_HPP

#ifdef _OPENMP
#include <omp.h>
#endif

/**
* return true iff the current thread is the master thread.
* In case of non-OpenMP loop, always return true
*/
// N.B: inline is critical here
inline bool openmp_is_master() {
#ifdef _OPENMP
  return omp_get_thread_num() == 0;
#else
  return true;
#endif
}

#endif
