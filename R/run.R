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
#' code = c("install.packages('ctv')", "library('ctv')", "available.views()")
#' run(code, "ismailsunni/gnur-3.6.1-debian-geospatial")
#'
#' # With multiple expressions
#' # This one is not working, see https://github.com/ismailsunni/altRnative/issues/1
#' # run(c(expression(a = 1 + 1, b = a + 2)), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' # This one is working
#' code = expression(install.packages("ctv"), library("ctv"), available.views())
#' run(code, "ismailsunni/gnur-3.6.1-debian-geospatial")
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
#' file_path <- system.file('extdata/test.R', package = 'altRnative')
#' run_file(file_path, "ismailsunni/gnur-3.6.1-debian-geospatial")
run_file <- function(r_file, docker_image){
  # Prepare docker container
  docker <- stevedore::docker_client()

  # Debug purpose
  print("Full command")
  print(c("Rscript", r_file))

  # Create container
  container <- docker$container$create(docker_image, c("R", "--no-save"), tty = TRUE)
  container$start()
  # Get working directory
  work_dir <- container$exec("pwd")$output
  # Remove new line character
  work_dir <- gsub("\n", "", work_dir)
  # Copy R file to docker, need to create the directory first
  dir_r_file <- dirname(r_file)
  container$exec(c("mkdir", "-p", dir_r_file))
  docker_file_path <- gsub("//", "/", r_file)
  container$cp_in(r_file, docker_file_path)
  # Run the file
  result <- container$exec(c("Rscript", docker_file_path))

  container$stop()
  container$remove()
  return(result)
}
