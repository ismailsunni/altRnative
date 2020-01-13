test_that("can run code string in a container", {
  skip_on_cran()

  capture_messages(capture_warnings(
    result <- run_code("a = 1 + 1; cat('result:', a)", "debian", "gnu-r")
  ))
  expect_equal(toString(result$logs), "result: 2")
})

test_that("can run file in a container", {
  skip_on_cran()

  capture_messages(capture_output(capture_warnings(
    result <- run_file(system.file('extdata/test.R', package = 'altRnative'), "debian", "gnu-r")
  )))

  expect_match(toString(result$output), '(.*)start(.*)4(.*)fin(.*)')
})
