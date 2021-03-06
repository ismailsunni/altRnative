% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{normalize_benchmark_result}
\alias{normalize_benchmark_result}
\title{Normalize benchmark result}
\usage{
normalize_benchmark_result(benchmark_result, baseline_image = NULL)
}
\arguments{
\item{benchmark_result}{Benchmark result from altRnative}

\item{baseline_image}{The docker image that is used for baseline. If NULL, use overall mean duration.}
}
\description{
Normalize the result of benchmarking with some default values
}
