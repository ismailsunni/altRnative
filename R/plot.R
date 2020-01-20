#' Normal box plot
#'
#' Plot a box plot from the result of benchmarking with some default
#'
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

#' Normalize box plot
#'
#' Plot a normalize box plot from the result of benchmarking with some default values
#'
#' @export
normalize_benchmark_boxplot <- function(
  benchmark_result,
  log = FALSE,
  xlab = 'Docker Images',
  ylab = 'Duration Ratio',
  ylim = NULL,
  ...
){
  normalize_benchmark_result =  benchmark_result
  normalize_benchmark_result[[2]] = normalize_benchmark_result[[2]] / min(normalize_benchmark_result[[2]])

  if (is.null(ylim)){
    # From 0 to ceiling(max) + 1 second
    ylim = c(0, ceiling(max(normalize_benchmark_result[[2]])))
  }

  boxplot(
    normalize_benchmark_result,
    log = log,
    ylim = ylim,
    xlab = xlab,
    ylab = ylab,
    ...
  )
}

