#' Run benchmark for R code across R implementation and platform
#'
#' Run benchmark for R code across R implementation and platform.
#' @param code An expression or string of R code
#' @inheritParams benchmarks
#' @export
#' @examples
#'
#' \dontrun{
#' benchmarks_code(code = "1 + 1", times = 3)
#'
#' # This code below is for running sample, need to set proper directory
#' code = expression(setwd('/home/docker/sdsr'),
#'                     bookdown::clean_book(TRUE),
#'                     unlink('_book/', recursive=TRUE),
#'                     unlink('_bookdown_files', recursive=TRUE),
#'                     bookdown::render_book('index.Rmd', 'bookdown::gitbook')
#' )
#' benchmarks_code(code = code,
#'                 volumes = '/home/ismailsunni/dev/r/sdsr:/home/docker/sdsr',
#'                 times = 3)
#' benchmarks_code(code = code,
#'                 platforms = c("debian", "ubuntu", "fedora"),
#'                 volumes = '/home/ismailsunni/dev/r/sdsr:/home/docker/sdsr',
#'                 times = 3)
#' }
benchmarks_code <- function(code,
                            platforms = c("debian", "ubuntu"),
                            r_implementations = c("gnu-r", "mro"),
                            volumes = NULL,
                            times = 3,
                            pull_image = FALSE,
                            ...){
  benchmarks("run_code",
             code = code,
             platforms = platforms,
             r_implementations = r_implementations,
             volumes = volumes,
             times = times,
             pull_image = pull_image,
             ... = ...)
}


#' Run benchmark for R code file across R implementation and platform
#'
#' Run benchmark for R code file across R implementation and platform.
#' @param r_file A file of R code
#' @inheritParams benchmarks
#' @export
#' @examples
#' \dontrun{
#' file_path <- system.file('extdata/test.R', package = 'altRnative')
#' benchmarks_file(file_path, times = 3)
#' }
benchmarks_file <- function(r_file,
                            platforms = c("debian", "ubuntu"),
                            r_implementations = c("gnu-r", "mro"),
                            volumes = NULL,
                            pull_image = FALSE,
                            times = 3, ...){
  benchmarks("run_file",
             code_or_file = r_file,
             platforms = platforms,
             r_implementations = r_implementations,
             volumes = volumes,
             times = times,
             pull_image = pull_image,
             ... = ...)
}

#' Internal function for benchmark execution
#' @importFrom microbenchmark microbenchmark
#'
#' @param platforms List of platforms
#' @param r_implementations List of R implementations
#' @param volumes Volume mapping from host to container. Passed to \link{run_code}
#' @param times How many times the code will be run. Passed to \link{microbenchmark}
#' @param pull_image If set to TRUE, the needed docker image will be pulled first
#' @param ... Parameters for \link[microbenchmark]{microbenchmark}
#'
#' @keywords internal
benchmarks <- function(run_function,
                       code_or_file,
                       platforms = c("debian", "ubuntu"),
                       r_implementations = c("gnu-r", "mro"),
                       volumes = volumes,
                       times = 3,
                       pull_image = pull_image,
                       ...){
  cat("Running benchmark with ", r_implementations, " on ", platforms,
      " for code '", toString(code_or_file), "'\n")

  expressions = list()
  if (pull_image){
    pull_docker_image(platforms, r_implementations)
  }
  for (r_implementation in r_implementations){
    for (platform in platforms){
      imageFound <- length(docker_image(platform, r_implementation)) > 0

      if (imageFound){
        e = call(run_function, code_or_file, platform, r_implementation, volumes)
        expressions[[paste(r_implementation, "on", platform)]] <- e
      } else {
        warning(paste('Docker image for', r_implementation, "and", platform, "not found, not running benchmark"))
      }
    }
  }
  microbenchmark::microbenchmark(list = expressions, times = times, ...)
}
