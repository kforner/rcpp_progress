
load_my_example_pkg <- function(pkg, ...) {
  skip_if(!requireNamespace("devtools", quietly = TRUE),
    message = "Package devtools must be installed to run unit tests.")

  from <- system.file(file.path('examples', pkg), package = 'RcppProgress')
  dir <- tempfile()
  dir.create(dir)
  file.copy(from, dir, recursive = TRUE)
  path <- file.path(dir, pkg)

  devtools::load_all(path, quiet = TRUE, ...)
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
  skip_if(!requireNamespace("RcppArmadillo", quietly = TRUE),
          message = "Package RcppArmadillo must be installed to run this test.")
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

