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

#' Get docker image for a combination of a platform and a R implementation.
#'
#' Return the name of docker image. Return empty string if the combination is not supported.
#' @import dplyr
#' @param platform The platform name see \link{supported_platforms}
#' @param r_implementation The R implementation name. See \link{supported_Rs}
#' @export
#' @examples
#' library("altRnative")
#' docker_image("debian", "gnu-r")
#' docker_image("ubuntu", "mro")
#' docker_image("debian", "renjin")
docker_image <- function(platform, r_implementation){
  table <- tibble(
    dist = c("debian", "ubuntu"),
    R = c("gnu-r", "mro"),
    image_name = c("ismailsunni/gnur-3.6.1-debian-geospatial", "ismailsunni/mro-3.5.3-ubuntu-geospatial"))
  result <- dplyr::filter(table, dist == platform, R == r_implementation)
  return( pull(result, "image_name"))
}



