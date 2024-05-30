
# load an example package (from inst/examples/)
load_my_example_pkg <- function(pkg, recompile = FALSE, ...) {
  if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("Package devtools must be installed to run unit tests.", call. = FALSE)
  }
  path <- system.file(file.path('examples', pkg), package = 'RcppProgress')
  devtools::load_all(path, quiet = TRUE, recompile = recompile, ...)
}

# small utility to bypass R CMD check 
get_function_from_pkg <- function(pkg, fun) {
  get(fun, getNamespace(pkg))
}

#' runs the sequential test from the RcppProgressExample example R package
#' @inherit test_multithreaded
#' @export
test_sequential <- function(max = 100, nb = 1000, display_progress = TRUE) {
  pkg <- 'RcppProgressExample'
  load_my_example_pkg(pkg)
  fun <- get_function_from_pkg(pkg, 'test_sequential')
  fun(max, nb, display_progress)
}


#' runs the multithreaded test from the RcppProgressExample example R package
#' @param max   the number of loops/increments to execute
#' @param nb    a parameter controlling the number of computations executed in each loop, so the time 
#'              complexity is quadratic in this parameter
#' @param display_progress  whether to display the progress bar
#' @param threads the number of OMP threads to use for the computation. If < 0, runs in sequential mode.
#' @return the computed number, or -1 if the computation was aborted
#' @export
test_multithreaded <- function(max = 100, nb = 1000, threads = 0, display_progress = TRUE)
{
  pkg <- 'RcppProgressExample'
  load_my_example_pkg(pkg)
  fun <- get_function_from_pkg(pkg, 'test_multithreaded')
  fun(max, nb, threads, display_progress)
}

#' runs the multithreaded test from the RcppProgressArmadillo example package
#' @inherit test_multithreaded
#' @export
test_amardillo_multithreaded <- function(max = 100, nb = 1000, threads = 0, display_progress = TRUE)
{
  testthat::skip_if_not_installed('RcppArmadillo')
  pkg <- 'RcppProgressArmadillo'
  load_my_example_pkg(pkg)
  fun <- get_function_from_pkg(pkg, 'test_multithreaded')
  fun(max, nb, threads, display_progress)
}

#' runs the test from the RcppProgressETA example package
#' @inherit test_multithreaded
#' @export
test_eta_progress_bar <- function(max = 100, nb = 1000, display_progress = TRUE)
{
  pkg <- 'RcppProgressETA'
  load_my_example_pkg(pkg)
  fun <- get_function_from_pkg(pkg, 'test_sequential')
  fun(max, nb, display_progress)
}

