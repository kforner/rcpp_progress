/*
 * interruptor.hpp
 *
 * A "static" class that manages interruptions in a openMP context
 * Author: karl.forner@gmail.com
 *
 */
#ifndef RcppProgress_INTERRUPTOR_HPP
#define RcppProgress_INTERRUPTOR_HPP

#include "interrupts.hpp"
#include "openmp_utils.hpp"


static bool& interruptor_is_aborted() {
  static bool aborted = false;
  return aborted;
}

/**
* request computation abortion
*/
static void interruptor_abort() {
#ifdef _OPENMP
#pragma omp critical
#endif
  interruptor_is_aborted() = true;
}

static bool interruptor_check_abort() {
  if ( interruptor_is_aborted() ) return true;
  if ( !openmp_is_master() ) return false;

  if ( checkInterrupt() ) interruptor_abort();
  return true;
}

#endif
