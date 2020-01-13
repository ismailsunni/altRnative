
test_that("default benchmark with simple expression works", {
  skip_on_cran()

  capture_output(capture_warnings(capture_messages(
    result <- benchmarks_code(expression(1+1))
  )))

  expect_s3_class(result, "data.frame")
  expect_equal(levels(result$expr), c("gnu-r on debian", "mro on ubuntu"))
  expect_length(result$time, 3 * 2)
})

test_that("default benchmark with file works", {
  skip_on_cran()

  capture_output(capture_warnings(capture_messages(
    result <- benchmarks_file(system.file('extdata/test.R', package = 'altRnative'))
  )))

  expect_s3_class(result, "data.frame")
  expect_equal(levels(result$expr), c("gnu-r on debian", "mro on ubuntu"))
  expect_length(result$time, 3 * 2)
})

test_that("can configure platform and image", {
  skip_on_cran()

  capture_output(capture_warnings(capture_messages(
    result <- benchmarks_code(expression(99*999), platforms = c("debian"), r_implementations = "gnu-r")
  )))

  expect_equal(levels(result$expr), c("gnu-r on debian"))
})

test_that("not supported images are not benchmarked with informative message", {
  skip_on_cran()

  expect_warning(
    benchmarks_code(expression(1+1),
                    platforms = c("not-a-linux", "debian"), r_implementations = c("myR", "gnu-r")),
    "Docker image for myR and not-a-linux not found, not running benchmark"
  )
})

test_that("image pulling can be enabled", {
  skip_on_cran()

  output <- capture_output(
    capture_warnings(
      messages <- capture_messages(
        benchmarks_code(expression(1+2+3), platforms = c("debian", "fedora"), r_implementations = "gnu-r",
                        pull_image = TRUE)
      )
    )
  )

  expect_match(output, "Pulling from ismailsunni/gnur-3.6.1-debian-geospatial")
  expect_match(output, "Pulling from ismailsunni/gnur-3.6.1-fedora-geospatial")
})

test_that("number of executions can be configured", {
  skip_on_cran()

  capture_output(capture_messages(capture_warnings(
    result <- benchmarks_code(expression(1+1),
                              platforms = "debian", r_implementations = "gnu-r",
                              times = 2,
                              unit = "ns")
  )))

  expect_length(result$time, 2)
})

test_that("options can be passed to microbenchmark", {
  skip_on_cran()

  capture_output(capture_messages(capture_warnings(
    result <- benchmarks_code(expression(1+1),
                              platforms = "debian", r_implementations = "gnu-r",
                              times = 1,
                              unit = "ns")
  )))

  expect_equal(attr(result, "unit"), "ns")
})
