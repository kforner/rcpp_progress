load_my_example_pkg <- function(pkg, recompile = TRUE, ...) {
  path <- system.file(file.path('examples', pkg), package = 'RcppProgress')
  load_all(path, quiet = TRUE, recompile = recompile, ...)
}

get_function_from_pkg <- function(pkg, fun) {
  get(fun, getNamespace(pkg))
}

test_sequential <- function(max = 100, nb = 1000, display_progress= TRUE, ...) {
  pkg <- 'RcppProgressExample'
  load_my_example_pkg(pkg, ...)
  fun <- get_function_from_pkg(pkg, 'test_sequential')
  fun(max, nb, display_progress)
}

# R wrapper for the example function #2
test_multithreaded <- function(max = 100, nb = 1000, threads = 0,
    display_progress = TRUE, ...)
{
  pkg <- 'RcppProgressExample'
  load_my_example_pkg(pkg, ...)
  fun <- get_function_from_pkg(pkg, 'test_multithreaded')
  fun(max, nb, threads, display_progress)
}


amardillo_multithreaded <- function(max = 100, nb = 1000, threads = 0,
  display_progress = TRUE, ...)
{
  testthat::skip_if_not_installed('RcppArmadillo')
  pkg <- 'RcppProgressArmadillo'
  load_my_example_pkg(pkg, ...)
  fun <- get_function_from_pkg(pkg, 'test_multithreaded')
  fun(max, nb, threads, display_progress)
}

eta_progress_bar <- function(max = 100, nb = 1000, display_progress = TRUE)
{
  pkg <- 'RcppProgressETA'
  load_my_example_pkg(pkg)
  fun <- get_function_from_pkg(pkg, 'test_sequential')
  fun(max, nb, display_progress)
}

