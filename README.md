
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stockr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/stockr)](https://CRAN.R-project.org/package=stockr)
<!-- badges: end -->

`stockr` is an R package that retrieve financial data from the Yahoo
Finance API, given company names or stock ‘ticker’ symbols.

> `stockr` functions return a standardized `data.frame` with consistent
> column names, allowing you to focus directly on financial analysis.

## Installation

You can install the development version of stockr:

``` r
devtools::install_github("clement-LVD/stockr")
```

## Examples

**Fetch ticker symbol and actual values (scraping).** Given a keyword,
search informations on <https://finance.yahoo.com/lookup/> with
`stockr::fetch_indices`

``` r
library(stockr)
# get all the values answered by https://finance.yahoo.com/lookup/
indices <- fetch_indices(names = c("TOYOTA")  )
str(indices) # all the last results over all marketplaces
#> 'data.frame':    25 obs. of  7 variables:
#>  $ symbol           : chr  "TM" "TOMA.MU" "7203.T" "TAH0.MU" ...
#>  $ name             : chr  "Toyota Motor Corporation" "TOYOTA MOTOR CORP.            R" "TOYOTA MOTOR CORP" "Toyota Industries Corp.       R" ...
#>  $ last price       : chr  "190.70" "178.00" "2,844.50" "86.00" ...
#>  $ sector / category: chr  "Consumer Cyclical" "Consumer Cyclical" "Consumer Cyclical" "Industrials" ...
#>  $ type             : chr  "Stocks" "Stocks" "Stocks" "Stocks" ...
#>  $ exchange         : chr  "NYQ" "MUN" "JPX" "MUN" ...
#>  $ searched         : chr  "TOYOTA" "TOYOTA" "TOYOTA" "TOYOTA" ...
```

Typically, you first retrieve the exact ticker symbol by analyzing the
results of `stockr::fetch_indices`. Then, you can use this symbol to
fetch the corresponding historical financial data (see below).

**Fetch historical financial data (Yahoo API).**

``` r
# (Optionally filter a precise marketplace)
indices <- fetch_indices(names = c("VOLVO", "SAAB"), marketplaces = "STO")
# We keep only the swedish marketplace (STOckholm) informations

# Fetch historical values, given ticker symbol(s)
datas <- fetch_historic(symbols = indices$symbol)
#> 
#> => 4 request(s) to Yahoo Finance (ETA :  1  sec')VOLCAR-B.ST [OK]                                                                                                    VOLV-A.ST [OK]                                                                                                    VOLV-B.ST [OK]                                                                                                    SAAB-B.ST [OK]                                                                                                    

str(datas)
#> 'data.frame':    20070 obs. of  15 variables:
#>  $ open            : num  58.8 65.6 60.6 58 59.5 ...
#>  $ close           : num  65.2 60.6 58 58.9 59.1 ...
#>  $ high            : num  67.4 68.4 60.8 58.9 59.9 ...
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

The `stockr` functions (`fetch_historic` & `fetch_indices`) returns a
standardized `data.frame` containing financial data from the Yahoo
Finance API:

- The variable names in the returned `data.frame` are consistent and
  inherited directly from the Yahoo Finance API, although they are
  converted to lowercase.

- The returned data is always in the form of a simple `data.frame`
  object, i.e. does not return time series objects.

- No specific data analysis package dependencies are imposed on the user
  : no assumptions are made about the analysis tools you’ll used (e.g.,
  no dependencies on `zoo` or `xts` for time series analysis).

It is up to the user to create more advanced data analysis objects from
the returned data.
