#' Normal box plot
#'
#' Plot a box plot from the result of benchmarking with some default
#' @importFrom graphics boxplot
#' @param benchmark_result Benchmark result from altRnative
#' @param log Set to TRUE If use log (time), else FALSE
#' @param xlab The lab for x axis
#' @param ylab The lab for y axis
#' @param ylim Range for ye axis, if NULL, set to max + 1 seconds
#' @param ... Parameters passed on boxplot method
#' @export
benchmark_boxplot <- function(
  benchmark_result,
  log = FALSE,
  xlab = 'Docker Images',
  ylab = 'Duration (seconds)',
  ylim = NULL,
  ...
  ){
  if (is.null(ylim)){
    # From 0 to ceiling(max) + 1 second
    ylim = c(0, ceiling(max(benchmark_result[[2]]) / 1000000000 * 1.1))
  }
  boxplot(
    benchmark_result,
    log = log,
    ylim = ylim,
    xlab = xlab,
    ylab = ylab,
    ...
  )
}

#' Normalize benchmark result
#'
#' Normalize the result of benchmarking with some default values
#' @param benchmark_result Benchmark result from altRnative
#' @param baseline_image The docker image that is used for baseline. If NULL, use overall mean duration.
#' @export
normalize_benchmark_result <- function(benchmark_result, baseline_image = NULL){
  normal_benchmark_result =  benchmark_result
  if (is.null(baseline_image)){
    baseline_duration = mean(normal_benchmark_result$time)
  } else {
    baseline_duration = mean(subset(normal_benchmark_result, normal_benchmark_result$expr==baseline_image)$time)
  }
  normal_benchmark_result[[2]] = normal_benchmark_result[[2]] / baseline_duration
  return(normal_benchmark_result)
}

#' Normalize box plot
#'
#' Plot a normalize box plot from the result of benchmarking with some default values
#' @importFrom graphics boxplot
#' @param benchmark_result Benchmark result from altRnative
#' @param baseline_image The docker image that is used for baseline. If NULL, use overall mean duration.
#' @param log Set to TRUE If use log (time), else FALSE
#' @param xlab The lab for x axis
#' @param ylab The lab for y axis
#' @param ylim Range for ye axis, if NULL, set to max + 1 seconds
#' @param ... Parameters passed on boxplot method
#' @export
normalize_benchmark_boxplot <- function(
  benchmark_result,
  baseline_image = NULL,
  log = FALSE,
  xlab = 'Docker Images',
  ylab = 'Duration Ratio',
  ylim = NULL,
  ...
){
  normal_benchmark_result = normalize_benchmark_result(benchmark_result, baseline_image)

  if (is.null(ylim)){
    # From 0 to ceiling(max) + 1 second
    ylim = c(0, ceiling(max(normal_benchmark_result[[2]])))
  }

  boxplot(
    normal_benchmark_result,
    log = log,
    ylim = ylim,
    xlab = xlab,
    ylab = ylab,
    ...
  )
}

