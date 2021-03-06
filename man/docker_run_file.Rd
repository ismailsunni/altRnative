% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run.R
\name{docker_run_file}
\alias{docker_run_file}
\title{Run a R file in a docker image}
\usage{
docker_run_file(r_file, docker_image, volumes = NULL, ...)
}
\arguments{
\item{r_file}{A file of R code}

\item{docker_image}{A docker image name}

\item{volumes}{Volume mapping from host to container}

\item{...}{Parameters passed on to \link{stevedore} client creation and container running functions}
}
\description{
Run a R file in a docker image
}
\examples{
\dontrun{
file_path <- system.file('extdata/test.R', package = 'altRnative')
docker_run_file(file_path, "ismailsunni/gnur-3.6.1-debian-geospatial")
}
}
