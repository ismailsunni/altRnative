#' Run benchmark for R code across R implementation and platform
#'
#' Run benchmark for R code across R implementation and platform.
#' @import microbenchmark
#' @param code An expression or string of R code
#' @param r_implementations List of R implementation
#' @param platforms List of platform
#' @export
#' @examples
#' benchmarks_code(code = "1 + 1")
benchmarks_code <- function(code, r_implementations = c("gnu-r", "mro"), platforms = c("debian", "ubuntu")){
  print(code)
  print(r_implementations)
  print(platforms)
  expressions = c()
  for (r_implementation in r_implementations){
    for(platform in platforms){
      if (length(docker_image(platform, r_implementation)) > 0){
        e = call("run_code", code, platform, r_implementation)
        expressions <- append(expressions, e)
      } else {
        print(paste('Docker image for', r_implementation, "and", platform, "is not supported"))
      }
    }
  }
  print(expressions)
  microbenchmark::microbenchmark(list = expressions, times = 1)
}
