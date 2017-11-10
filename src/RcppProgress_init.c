/* generated using  tools::package_native_routine_registration_skeleton(".") */

#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP test_multithreaded_wrapper(SEXP, SEXP, SEXP, SEXP);
extern SEXP test_sequential_wrapper(SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"test_multithreaded_wrapper", (DL_FUNC) &test_multithreaded_wrapper, 4},
    {"test_sequential_wrapper",    (DL_FUNC) &test_sequential_wrapper,    3},
    {NULL, NULL, 0}
};

void R_init_RcppProgress(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
