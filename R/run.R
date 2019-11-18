#' Run a code in a docker image
#'
#' Run a a code as a string in a docker image
#' @import stevedore
#' @param code An expression of R code
#' @param docker_image A docker image name
#' @export
#' @examples
#' library("altRnative")
#' run(expression(1 + 1), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' run(expression(install.packages("ctv")), "ismailsunni/gnur-3.6.1-debian-geospatial")
#' run(c(expression(install.packages("ctv")), expression(library("ctv")), expression(available_views())), "ismailsunni/gnur-3.6.1-debian-geospatial")
run <- function(code, docker_image){
  print(code)
  print(docker_image)
  # Prepare docker container
  docker <- stevedore::docker_client()
  print(c("Rscript", "-e", paste0("eval(", code, ")")))
  # Run using stevedore
  result <- docker$container$run(docker_image, c("Rscript", "-e", paste0("eval(", code, ")")), rm = TRUE)
  result$logs
}
