
# RcppProgressExample pakcage
test_that("RcppProgressExample", {

  ### sequential
  expect_error(res1 <- test_sequential(1, 1000, FALSE), NA)
  
  expect_error(res2 <- test_sequential(10, 1000, TRUE), NA)
  expect_equal(res2, 10*res1)

  ### multithreaded
  expect_error(test_multithreaded(nb = 1000, threads = 4), NA)

})

test_that("test_multithreaded", {
  expect_error(test_multithreaded(nb = 1000, threads = 4), NA)
})

test_that("amardillo_multithreaded", {
  expect_error(test_amardillo_multithreaded(nb = 1000, threads = 4), NA)
})


test_that("eta_progress_bar", {
  expect_error(test_eta_progress_bar(nb = 1000), NA)
})
