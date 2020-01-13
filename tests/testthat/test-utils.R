
test_that("supported platforms is a non-empty named list", {
  expect_true(is.list(supported_platforms()))
  expect_gt(length(supported_platforms()), 1)
  expect_named(supported_platforms())
})

test_that("supported Rs is a non-empty named list", {
  expect_true(is.list(supported_Rs()))
  expect_gt(length(supported_Rs()), 1)
  expect_named(supported_Rs())
})

test_that("compatibility table is a table", {
  expect_true(is.data.frame(compatibility_table()))
  expect_s3_class(compatibility_table(), "tbl")
})

test_that("compatibility table has all supported platforms and vice versa", {
  expect_setequal(compatibility_table()$dist, names(supported_platforms()))
})

test_that("compatibility table has all supported Rs and vice versa", {
  expect_setequal(compatibility_table()$R, names(supported_Rs()))
})

test_that("default image is correct", {
  expect_equal(docker_image(), "ismailsunni/gnur-3.6.1-debian-geospatial")
})

test_that("supported images can be pulled", {
  skip_on_cran()

  capture_warnings(capture_messages(
    output <- capture_output(pull_docker_image())
  ))

  # by default two images are pulled
  expect_match(output, "Pulling from ismailsunni/gnur-3.6.1-debian-geospatial")
  expect_match(output, "Pulling from ismailsunni/mro-3.5.3-ubuntu-geospatial")
})

test_that("configuration can be passed to stevedore", {
  skip_on_cran()

  capture_warnings(capture_output(
    messages <- capture_messages(pull_docker_image(stevedore_opts = list(api_version = "0.0")))
  ))

  expect_match(messages, "Requested API version '0.0' is below min version")
})

test_that("not supported images are not pulled with informative warning", {
  expect_warning(result <- pull_docker_image(platforms = c("not-a-linux"), r_implementations = c("myR")),
               "Docker image for myR and not-a-linux is not supported")
  expect_null(result)
})
