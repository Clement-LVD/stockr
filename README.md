
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stockr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/stockr)](https://CRAN.R-project.org/package=stockr)
<!-- badges: end -->

`stockr` is an R package that retrieve financial data from the Yahoo
Finance API, given company names or ticker symbols[^1].

> `stockr` functions return a standardized `data.frame` with consistent
> column names, allowing you to focus directly on financial analysis.

## Installation

You can install the development version of stockr:

``` r
devtools::install_github("clement-LVD/stockr")
```

## Examples

**Fetch ticker symbol and actual values.** Given keyword(s) such
companies names, search latest stock values with
`stockr::fetch_info_from_name`.

``` r
library(stockr)

toyota_indices <- stockr::fetch_info_from_name(names = "TOYOTA")

head(toyota_indices, 2) # Results of the day, over all marketplaces
#>   symbol                     name last price            sector   type exchange
#> 1     TM Toyota Motor Corporation     193.01 Consumer Cyclical Stocks      NYQ
#> 2 7203.T        TOYOTA MOTOR CORP   2,882.50 Consumer Cyclical Stocks      JPX
#>   searched
#> 1   TOYOTA
#> 2   TOYOTA
```

Typically, you start by retrieving an exact ticker symbol using
`stockr::fetch_info_from_name` or another way. You can then use these
ticker symbols to fetch the corresponding historical financial data (see
below).

**Fetch historical financial data with.** Given ticker symbol(s), get
financial values with `stockr::fetch_historic` :

``` r

# Fetch historical values, given ticker symbol(s)
histo <- stockr::fetch_historic(symbols = c("SAAB-B.ST", "VOLV-B.ST"), .verbose = FALSE)

head(histo,n =  1)
#>       open    close adjclose      low     high volume timestamp
#> 1 18.48825 17.44829 9.860821 16.87053 18.48825 313414 946886400
#>                  date currency    symbol      shortname       longname
#> 1 2000-01-03 09:00:00      SEK SAAB-B.ST SAAB AB ser. B Saab AB (publ)
#>   exchangename fullexchangename timezone
#> 1          STO        Stockholm      CET
```

This `data.frame` contain daily values.

**Chaining examples 1 & 2.** Fetch ticker symbols associated with
keyword(s) such as companies names, and get historical financial data
for these symbols.

``` r
# 1) fetch_indices (optionally filter a precise marketplace)
indices <- stockr::fetch_info_from_name(names = c("VOLVO", "RENAULT")
                         , exchange = "STO")
# Keep only the swedish exchange place (STOckholm)

# 2) Fetch historical values, given ticker symbol(s)
datas <- stockr::fetch_historic(symbols = indices$symbol)
#> 
#> => 3 request(s) to Yahoo Finance (ETA :  0.9  sec')  VOLCAR-B.ST [OK]                                                                                                      VOLV-A.ST [OK]                                                                                                      VOLV-B.ST [OK]                                                                                                    

str(datas)
#> 'data.frame':    13671 obs. of  15 variables:
#>  $ open            : num  58.8 65.6 60.6 58 59.5 ...
#>  $ close           : num  65.2 60.6 58 58.9 59.1 ...
#>  $ adjclose        : num  65.2 60.6 58 58.9 59.1 ...
#>  $ low             : num  55 59 56.6 55.8 58 ...
#>  $ high            : num  67.4 68.4 60.8 58.9 59.9 ...
#>  $ volume          : int  70977504 20388814 14497507 7963166 2874916 1228461 2989143 1889096 1866615 7365218 ...
#>  $ timestamp       : int  1635490800 1635753600 1635840000 1635926400 1636012800 1636099200 1636358400 1636444800 1636531200 1636617600 ...
#>  $ date            : POSIXct, format: "2021-10-29 09:00:00" "2021-11-01 09:00:00" ...
#>  $ currency        : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol          : chr  "VOLCAR-B.ST" "VOLCAR-B.ST" "VOLCAR-B.ST" "VOLCAR-B.ST" ...
#>  $ shortname       : chr  "Volvo Car AB ser. B" "Volvo Car AB ser. B" "Volvo Car AB ser. B" "Volvo Car AB ser. B" ...
#>  $ longname        : chr  "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" ...
#>  $ exchangename    : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename: chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone        : chr  "CET" "CET" "CET" "CET" ...
#>  - attr(*, "fetch.symbols")= chr [1:3] "VOLCAR-B.ST" "VOLV-A.ST" "VOLV-B.ST"
#>  - attr(*, "fetch.date")= Date[1:1], format: "2025-03-26"
#>  - attr(*, "fetch.currencies")= chr "SEK"
#>  - attr(*, "n.currencies")= int 1
```

## Technical details

**Sources.**`stockr::fetch_info_from_name()` scrap data from
<https://finance.yahoo.com/lookup/> ; and `stockr::fetch_historic()`
reach the Yahoo Finance API.

**Role of stockr in the ‘Reach Yahoo Finance from R’ ecosystem.** Other
packages are partially redundant with `stockr` : `quantmod` and
`yahoofinancer`. `stockr` have the minimal amount of dependencies in
this ecosystem, but other packages certainly offer more functions, e.g.,
`quantmod` offers time series data visualization methods.

The `data.frame` of historical financial values returned by these
packages have different properties, see below.

| names | fetch_historic |
|:---|:---|
| stockr | `stockr::fetch_historic` return a standard `data.frame` |
| yahoofinancer | `yahoofinancer` methods return an `R6` class object (e.g., `Ticker$get_history`) |
| quantmod | `quantmod` return a time.series object (`quantmod::getSymbols` return a `xts` & `zoo` object) |

[^1]: <https://en.wikipedia.org/wiki/Ticker_symbol>
