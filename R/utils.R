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
