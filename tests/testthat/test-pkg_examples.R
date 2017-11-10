context('RcppProgressExample sequential\n')

.test_sequential <- function() {
  RcppProgress:::test_sequential(nb = 500)
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
