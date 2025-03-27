
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

**Main functions.**

| Function | Input | Return | Sources |
|:---|:---|:---|:---|
| `stockr::get_historic` | Ticker symbol(s), e.g., `'SAAB-B.ST'` | Daily historic of financial data | API\* |
| `stockr::get_changes` | Currencies, e.g., convert from `'USD'` to `'EUR'` | Latest exchange rates | API\* |
| `stockr::get_info_from_name` | Unstructured text value, e.g., company name(s) such as `'SAAB'` | Ticker symbols associated with the results, and latest financial insights on these symbols | Scraping<sup>†</sup> |
| `stockr::get_indices()` |  | World financial indices and their actual values | Scraping<sup>‡</sup> |

\* : Yahoo Finance API, e.g.,
<https://query1.finance.yahoo.com/v1/finance/currencies> <br>† :
Scraping from <https://finance.yahoo.com/lookup/> <br>‡ : Scraping from
<https://finance.yahoo.com/markets/world-indices/>

## Installation

You can install the development version of stockr:

``` r
devtools::install_github("clement-LVD/stockr")
```

## Examples

**Get ticker symbol and actual values.** Given keyword(s) such companies
names, search latest stock values with `stockr::get_info_from_name`.

``` r
library(stockr)

toyota_indices <- stockr::get_info_from_name(names = "TOYOTA")

head(toyota_indices, 1) # Results of the day, over all marketplaces
#>   symbol                     name last price            sector   type exchange
#> 1     TM Toyota Motor Corporation     189.28 Consumer Cyclical Stocks      NYQ
#>   searched
#> 1   TOYOTA
```

Typically, you start by retrieving an exact ticker symbol using
`stockr::get_info_from_name` or another way. You can then use these
ticker symbols to fetch the corresponding historical financial data (see
below).

**Get historical financial data.** Given ticker symbol(s), get historic
of financial values with `stockr::get_historic` :

``` r

# Fetch historical values, given ticker symbol(s)
histo <- stockr::get_historic(symbols = c("SAAB-B.ST", "VOLV-B.ST"), .verbose = FALSE)

str(histo)
#> 'data.frame':    12816 obs. of  15 variables:
#>  $ open            : num  18.5 17.7 17.1 17.1 16.5 ...
#>  $ close           : num  17.4 17.1 17.1 17.1 16.9 ...
#>  $ adjclose        : num  9.86 9.66 9.66 9.66 9.53 ...
#>  $ low             : num  16.9 16.4 17.1 17.1 16.5 ...
#>  $ high            : num  18.5 17.7 17.1 17.1 17 ...
#>  $ volume          : int  313414 294565 0 0 313418 264509 165960 205163 151425 214397 ...
#>  $ timestamp       : int  946886400 946972800 947059200 947145600 947232000 947491200 947577600 947664000 947750400 947836800 ...
#>  $ date            : POSIXct, format: "2000-01-03 09:00:00" "2000-01-04 09:00:00" ...
#>  $ currency        : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol          : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ shortname       : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ longname        : chr  "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" ...
#>  $ exchangename    : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename: chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone        : chr  "CET" "CET" "CET" "CET" ...
#>  - attr(*, "symbols")= chr [1:2] "SAAB-B.ST" "VOLV-B.ST"
#>  - attr(*, "date")= Date[1:1], format: "2025-03-27"
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "n.currencies")= int 1
```

Each lines of this `data.frame` are daily values.

## Technical details

**Role of stockr in the ‘Reach Yahoo Finance from R’ ecosystem.** Other
packages are partially redundant with `stockr` : `quantmod` and
`yahoofinancer`. `stockr` have the minimal amount of dependencies in
this ecosystem, but other packages certainly offer more functions, e.g.,
`quantmod` offers time series data visualization methods.

The `data.frame` of historical financial values returned by these
packages have different properties, see below.

| names | get_historic |
|:---|:---|
| stockr | `stockr::get_historic` return a standard `data.frame` |
| yahoofinancer | `yahoofinancer` methods return an `R6` class object (e.g., `Ticker$get_history`) |
| quantmod | `quantmod::getSymbols` return a time.series (`xts` & `zoo` object) |

[^1]: <https://en.wikipedia.org/wiki/Ticker_symbol>
