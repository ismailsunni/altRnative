#' Return supported platforms
#'
#' Return list of supported platforms with their key to access.
#' @export
#' @examples
#' library("altRnative)
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
