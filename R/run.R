#' Run a code in a docker image
#'
#' Run a code as a string in a docker image
#' @import stevedore
#' @param code An expression or string of R code
#' @param docker_image A docker image name
#' @param volumes Volume mapping from host to container
#' @export
#' @examples
#' library("altRnative")
#'
#' # With string
#' docker_run_code("a = 1 + 1", "ismailsunni/gnur-3.6.1-debian-geospatial")
#'
#' # With expression
#' docker_run_code(expression(1 + 1), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' docker_run_code(expression(a = 1 + 1), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' docker_run_code(expression(install.packages("ctv")), "ismailsunni/gnur-3.6.1-debian-geospatial")
#'
#' # With multiple string
#' docker_run_code(c("a = 1 + 1", "b = a + 2", "print(b)"), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' code = c("install.packages('ctv')", "library('ctv')", "available.views()")
#' docker_run_code(code, "ismailsunni/gnur-3.6.1-debian-geospatial")
#'
#' # With multiple expressions
#' # This one is not working, see https://github.com/ismailsunni/altRnative/issues/1
#' # docker_run_code(c(expression(a = 1 + 1, b = a + 2)), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' # This one is working
#' code = expression(install.packages("ctv"), library("ctv"), available.views())
#' docker_run_code(code, "ismailsunni/gnur-3.6.1-debian-geospatial")
#' # This code below is for running sample, need to set proper directory
#' # code = expression(setwd('/home/docker/sdsr'), bookdown::render_book('index.Rmd', 'bookdown::gitbook'))
#' # docker_run_code(code, "ismailsunni/gnur-3.6.1-debian-geospatial", volumes = '/home/ismailsunni/dev/r/sdsr:/home/docker/sdsr')
docker_run_code <- function(code, docker_image, volumes = NULL){
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
  result <- docker$container$run(docker_image, c("Rscript", "-e", full_code), rm = TRUE, volumes = volumes)

  return(result)
}


#' Run a R file in a docker image
#'
#' Run a R file in a docker image
#' @import stevedore
#' @param r_file A file of R code
#' @param docker_image A docker image name
#' @param volumes Volume mapping from host to container
#' @export
#' @examples
#' library("altRnative")
#' file_path <- system.file('extdata/test.R', package = 'altRnative')
#' docker_run_file(file_path, "ismailsunni/gnur-3.6.1-debian-geospatial")
docker_run_file <- function(r_file, docker_image, volumes = NULL){
  # Prepare docker container
  docker <- stevedore::docker_client()

  # Debug purpose
  print("Full command")
  print(c("Rscript", r_file))

  # Create container
  container <- docker$container$create(docker_image, c("R", "--no-save"), tty = TRUE, volumes = volumes)
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
  # TODO: Need to be modified based on the R implementation
  result <- container$exec(c("Rscript", docker_file_path))

  container$stop()
  container$remove()
  return(result)
}

#' Run a R file in a docker image of a platform and an R implementation
#'
#' Run a R file in a docker image  of a platform and an R implementation
#' @param r_file A file of R code
#' @param platform The platform name see \link{supported_platforms}
#' @param r_implementation The R implementation name. See \link{supported_Rs}
#' @export
#' @examples
#' library("altRnative")
#' file_path <- system.file('extdata/test.R', package = 'altRnative')
#' run_file(file_path, 'debian', 'gnu-r')
#' run_file(file_path, 'not-debian', 'gnu-r')
run_file <- function(r_file, platform = "debian", r_implementation = "gnu-r"){
  image_name <- docker_image(platform, r_implementation)
  if (length(image_name) > 0){
    return(docker_run_file(r_file, image_name))
  } else {
    print(paste("No Docker Image for", platform, "and", r_implementation))
  }
}

#' Run a R file in a docker image  of a platform and an R implementation
#' @param code An expression or string of R code
#' @param platform The platform name see \link{supported_platforms}
#' @param r_implementation The R implementation name. See \link{supported_Rs}
#' @export
#' @examples
#' run_code("a = 1 + 1", 'debian', 'gnu-r')
run_code <- function(code, platform = "debian", r_implementation = "gnu-r"){
  image_name <- docker_image(platform, r_implementation)
  if (length(image_name) > 0){
    return(docker_run_code(code, image_name))
  } else {
    print(paste("No Docker Image for", platform, "and", r_implementation))
  }
}
