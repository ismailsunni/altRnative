% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{docker_image}
\alias{docker_image}
\title{Get docker image for a combination of a platform and a R implementation.}
\usage{
docker_image(platform = "debian", r_implementation = "gnu-r")
}
\arguments{
\item{platform}{The platform name see \link{supported_platforms}}

\item{r_implementation}{The R implementation name. See \link{supported_Rs}}
}
\description{
Return the name of docker image. Return empty string if the combination is not supported.
}
\examples{
docker_image("debian", "gnu-r")
docker_image("ubuntu", "mro")
docker_image("debian", "renjin")
}
