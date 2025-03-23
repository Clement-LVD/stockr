
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stockr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/stockr)](https://CRAN.R-project.org/package=stockr)
<!-- badges: end -->

`stockr` is an R package that offers an efficient standardized approach
to retrieve financial data.

Data are fetched from the Yahoo Finance API, *given company names and/or
indices*.

`stockr` functions are designed to return a standardized `data.frame`
with standardized column names, values, and attributes. The package’s
aim is to help you to quickly reach the point where you have financial
data to analyze, but no assumptions are made about the analysis tools
you’ll used (e.g., no dependencies on `zoo` or `xts` for time series
analysis).

## Installation

You can install the development version of stockr:

``` r
devtools::install_github("clement-LVD/stockr")
```

## Example

``` r
library(stockr)
# get indices names on the swedish marketplace
indices <- fetch_stock_indices(names = c("VOLVO", "SAAB") , marketplaces = "STO")
# search for historical values
datas <- fetch_historic(symbols = indices$symbol )
#> ETA :  1  sec'

str(datas)
#> 'data.frame':    20070 obs. of  15 variables:
#>  $ high            : num  67.4 68.4 60.8 58.9 59.9 ...
#>  $ open            : num  58.8 65.6 60.6 58 59.5 ...
#>  $ close           : num  65.2 60.6 58 58.9 59.1 ...
#>  $ volume          : int  70977504 20388814 14497507 7963166 2874916 1228461 2989143 1889096 1866615 7365218 ...
#>  $ low             : num  55 59 56.6 55.8 58 ...
#>  $ adjclose        : num  65.2 60.6 58 58.9 59.1 ...
#>  $ timestamp       : int  1635490800 1635753600 1635840000 1635926400 1636012800 1636099200 1636358400 1636444800 1636531200 1636617600 ...
#>  $ date            : POSIXct, format: "2021-10-29 09:00:00" "2021-11-01 09:00:00" ...
#>  $ currency        : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol          : chr  "VOLCAR-B.ST" "VOLCAR-B.ST" "VOLCAR-B.ST" "VOLCAR-B.ST" ...
#>  $ longname        : chr  "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" ...
#>  $ shortname       : chr  "Volvo Car AB ser. B" "Volvo Car AB ser. B" "Volvo Car AB ser. B" "Volvo Car AB ser. B" ...
#>  $ exchangename    : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename: chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone        : chr  "CET" "CET" "CET" "CET" ...
```

## Programming philosophy

`stockr` offering a standardized `data.frame` and methods for retrieve
financial data.

- Company names can be provided to `stockr` instead of specific ticker
  symbols, allowing the package to rely on a standardized logic when the
  exact financial identifier of a company on a given stock exchange is
  unknown.

- The variable names in the returned `data.frame` are stable and
  inherited from the Yahoo Finance API, though they are converted to
  lowercase.

- The returned tables are always simple data.frame objects. Thus, it’s
  up to you to construct data-analysis objects, e.g., time series
  objects.

- Dependencies related to data analysis are not imposed to the user,
  e.g., there is no requirement for packages like `zoo` or `xts`.
