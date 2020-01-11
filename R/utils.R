#' Return supported platforms
#'
#' Return list of supported platforms with their key to access.
#' @export
#' @examples
#' library("altRnative")
#' supported_platforms()
supported_platforms <- function(){
  return(
    list(
      ("debian" = "Debian Linux"),
      ("fedora" = "Fedora Linux"),
      ("archlinux" = "Arch Linux")
    )
  )
}


#' Return supported R implementations
#'
#' Return list of supported R implementations with their key to access.
#' @export
#' @examples
#' library("altRnative")
#' supported_Rs()
supported_Rs <- function(){
  return(
    list(
      ("gnu-r" = "GNU R"),
      ("mro" = "Microsoft R Open"),
      ("renjin" = "Renjin"),
      ("fastr" = "FastR"),
      ("pqr" = "pqR"),
      ("terr" = "TERR")
    )
  )
}
#' Return a compatibility table
#'
#' Return a table that consist of platfom, R implementation, docker image name.
#' @importFrom dplyr tibble
#' @export
#' @examples
#' compatibility_table()
compatibility_table <- function(){
  dplyr::tibble(
    dist = c("debian", "ubuntu", "fedora", "archlinux", "fedora"),
    R = c("gnu-r", "mro", "gnu-r", "gnu-r", "mro"),
    image_name = c(
      "ismailsunni/gnur-3.6.1-debian-geospatial",
      "ismailsunni/mro-3.5.3-ubuntu-geospatial",
      "ismailsunni/gnur-3.6.1-fedora-geospatial",
      "ismailsunni/gnur-3.6.1-archlinux-geospatial",
      "ismailsunni/mro-3.5.3-fedora-30-geospatial"
      )
    )
}

#' Get docker image for a combination of a platform and a R implementation.
#'
#' Return the name of docker image. Return empty string if the combination is not supported.
#' @importFrom dplyr filter pull
#' @importFrom rlang .data
#' @param platform The platform name see \link{supported_platforms}
#' @param r_implementation The R implementation name. See \link{supported_Rs}
#' @export
#' @examples
#' library("altRnative")
#' docker_image("debian", "gnu-r")
#' docker_image("ubuntu", "mro")
#' docker_image("debian", "renjin")
docker_image <- function(platform = "debian", r_implementation = "gnu-r"){
  table <- compatibility_table()
  # import rlang::.data to avoid R check errors, see https://dplyr.tidyverse.org/articles/programming.html
  result <- dplyr::filter(table, .data$dist == platform, .data$R == r_implementation)
  return(dplyr::pull(result, "image_name"))
}

#' Pull docker image from docker hub. Public image only.
#'
#' For supported docker images only.
#' @importFrom stevedore docker_client
#' @param platforms List of platform
#' @param r_implementations List of R implementation
#' @export
#' @examples
#' \dontrun{
#' pull_docker_image('debian', 'gnu-r')
#' }
#'
pull_docker_image <- function(platforms = c("debian", "ubuntu"), r_implementations = c("gnu-r", "mro")){
  docker = stevedore::docker_client()
  for (r_implementation in r_implementations){
    for(platform in platforms){
      if (length(docker_image(platform, r_implementation)) > 0){
        docker$image$pull(docker_image(platform, r_implementation))
      } else {
        print(paste('Docker image for', r_implementation, "and", platform, "is not supported"))
      }
    }
  }
}

