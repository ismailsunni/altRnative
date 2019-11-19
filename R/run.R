#' Run a code in a docker image
#'
#' Run a code as a string in a docker image
#' @import stevedore
#' @param code An expression or string of R code
#' @param docker_image A docker image name
#' @export
#' @examples
#' library("altRnative")
#'
#' # With string
#' run("a = 1 + 1", "ismailsunni/gnur-3.6.1-debian-geospatial")
#'
#' # With expression
#' run(expression(1 + 1), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' run(expression(a = 1 + 1), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' run(expression(install.packages("ctv")), "ismailsunni/gnur-3.6.1-debian-geospatial")
#'
#' # With multiple string
#' run(c("a = 1 + 1", "b = a + 2", "print(b)"), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' run(c("install.packages('ctv')", "library('ctv')", "available.views()"), "ismailsunni/gnur-3.6.1-debian-geospatial")
#'
#' # With multiple expressions
#' # This one is not working, see https://github.com/ismailsunni/altRnative/issues/1
#' run(c(expression(a = 1 + 1, b = a + 2)), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' # This one is working
#' run(c(expression(install.packages("ctv")), expression(library("ctv")), expression(available.views())), "ismailsunni/gnur-3.6.1-debian-geospatial")
run <- function(code, docker_image){
  # Prepare docker container
  docker <- stevedore::docker_client()

  # Prepare the script
  if (is.expression(code)){
    code = as.character(code)
  }
  full_code <-paste(code, collapse = "; ")

  # Debug purpose
  print("Full command")
  print(c("Rscript", "-e", full_code))

  # Run using stevedore
  result <- docker$container$run(docker_image, c("Rscript", "-e", full_code), rm = TRUE)

  return(result)
}


#' Run a R file in a docker image
#'
#' Run a R file in a docker image
#' @import stevedore
#' @param r_file A file of R code
#' @param docker_image A docker image name
#' @export
#' @examples
#' library("altRnative")
#' run_file("check_packages.R", "ismailsunni/gnur-3.6.1-debian-geospatial")
run_file <- function(r_file, docker_image){
  # Prepare docker container
  docker <- stevedore::docker_client()

  # Debug purpose
  print("Full command")
  print(c("Rscript", r_file))

  # Run using stevedore
  result <- docker$container$run(docker_image, c("Rscript", r_file), rm = TRUE)

  return(result)
}
