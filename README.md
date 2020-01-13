
<!-- README.md is generated from README.Rmd. Please edit that file -->

# altRnative

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/ismailsunni/altRnative.svg?branch=master)](https://travis-ci.org/ismailsunni/altRnative)
<!-- badges: end -->

An R package to run you R code in different R implementations and
platforms in [Docker]() containers.

## Installation

You can install the development version [from
GitHub](https://github.com/ismailsunni/altRnative) with:

``` r
# install.packages("remotes")
remotes::install_github("ismailsunni/altRnative")
```

## Example

``` r
library('altRnative')
pull_docker_image(c('gnu-r', 'mro'), c('debian', 'ubuntu', 'fedora'))
#> Detected API version '1.40' is above max version '1.39'; downgrading

benchmark_result = benchmarks_code(
  code = "1 + 1", 
  r_implementations = c('gnu-r', 'mro'), 
  platforms = c('debian', 'ubuntu', 'fedora', 'archlinux'),
  times = 3
  )
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading
#> Detected API version '1.40' is above max version '1.39'; downgrading

library('ggplot2')
autoplot(benchmark_result)
#> Coordinate system already present. Adding new coordinate system, which will replace the existing one.
```

<img src="man/figures/README-example-1.png" width="100%" />

## Documentation

Documentation is created with [roxygen2](https://roxygen2.r-lib.org/)
and the website with [pkgdown](https://pkgdown.r-lib.org/). Render both
with the following commands:

``` r
roxygen2::roxygenise(roclets = c('rd', 'collate', 'namespace', 'vignette'))
pkgdown::build_site()
```

The file `README.md` is generated from `README.Rmd`. A [pre-commit
hook]() added with
[`usethis`](https://usethis.r-lib.org/reference/use_readme_rmd.html)
should be configured to make sure the Markdown file is always up to date
with the R Markdown file. Add the following to a file
`.git/hooks/pre-commit`:

``` bash
#!/bin/bash
README=($(git diff --cached --name-only | grep -Ei '^README\.[R]?md$'))
MSG="use 'git commit --no-verify' to override this check"

if [[ ${#README[@]} == 0 ]]; then
  exit 0
fi

if [[ README.Rmd -nt README.md ]]; then
  echo -e "README.md is out of date; please re-knit README.Rmd\n$MSG"
  exit 1
elif [[ ${#README[@]} -lt 2 ]]; then
  echo -e "README.Rmd and README.md should be both staged\n$MSG"
  exit 1
fi
```

## Contribute

Please note that the ‘altRnative’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.

## License

This project is published under MIT license, see file `LICENSE`.
