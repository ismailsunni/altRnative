#' Run benchmark for R code across R implementation and platform
#'
#' Run benchmark for R code across R implementation and platform.
#' @import microbenchmark
#' @param code An expression or string of R code
#' @param platforms List of platform
#' @param r_implementations List of R implementation
#' @param times How many times the code will be run. Passed to \link{microbenchmark}
#' @param ... Parameters for \link{microbenchmark}
#' @export
#' @examples
#' benchmarks_code(code = "1 + 1", times = 3)
benchmarks_code <- function(code, platforms = c("debian", "ubuntu"), r_implementations = c("gnu-r", "mro"), times = 3, ...){
  print(code)
  print(r_implementations)
  print(platforms)
  expressions = list()
  for (r_implementation in r_implementations){
    for(platform in platforms){
      if (length(docker_image(platform, r_implementation)) > 0){
        e = call("run_code", code, platform, r_implementation)
        expressions[[paste(r_implementation, "on", platform)]] <- e
      } else {
        print(paste('Docker image for', r_implementation, "and", platform, "is not supported"))
      }
    }
  }
  microbenchmark::microbenchmark(list = expressions, times = times, ...)
}


#' Run benchmark for R code file across R implementation and platform
#'
#' Run benchmark for R code file across R implementation and platform.
#' @import microbenchmark
#' @param r_file A file of R code
#' @param r_implementations List of R implementation
#' @param platforms List of platform
#' @param times How many times the code will be run. Passed to \link{microbenchmark}
#' @param ... Parameters for \link{microbenchmark}
#' @export
#' @examples
#' file_path <- system.file('extdata/test.R', package = 'altRnative')
#' benchmarks_file(file_path, times = 3)
benchmarks_file <- function(r_file, platforms = c("debian", "ubuntu"), r_implementations = c("gnu-r", "mro"), times = 3, ...){
  print(r_file)
  print(r_implementations)
  print(platforms)
  expressions = c()
  for (r_implementation in r_implementations){
    for(platform in platforms){
      if (length(docker_image(platform, r_implementation)) > 0){
        e = call("run_file", r_file, platform, r_implementation)
        expressions[[paste(r_implementation, "on", platform)]] <- e
      } else {
        print(paste('Docker image for', r_implementation, "and", platform, "is not supported"))
      }
    }
  }
  microbenchmark::microbenchmark(list = expressions, times = times, ...)
}
