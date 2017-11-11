context('RcppProgressExample sequential\n')

.test_sequential <- function() {
  expect_error(RcppProgress:::test_sequential(nb = 500), NA)
}
test_that("test_sequential", .test_sequential())


context('RcppProgressExample multithreaded\n')
.test_multithreaded <- function() {
  RcppProgress:::test_multithreaded(nb = 1000, threads = 4)
}
test_that("test_multithreaded", .test_multithreaded())


context('RcppProgressArmadillo multithreaded\n')
.amardillo_multithreaded <- function() {
  RcppProgress:::amardillo_multithreaded(nb = 1000, threads = 4)
}
test_that("amardillo_multithreaded", .amardillo_multithreaded())



context('RcppProgressETA:custom progress bar\n')
.eta_progress_bar <- function() {
  RcppProgress:::eta_progress_bar(nb = 1000)
}
test_that("eta_progress_bar", .eta_progress_bar())