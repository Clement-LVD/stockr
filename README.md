
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stockr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/stockr)](https://CRAN.R-project.org/package=stockr)
<!-- badges: end -->

`stockr` is an R package that retrieve financial data from Yahoo
Finance, in order to provide historic of financial values and helper
functions.

> `stockr` functions return a standardized *`data.frame`* with
> consistent column names, allowing you to focus directly on financial
> analysis.

**Main functions.**

| Minimal.example | Input | Return |
|:---|:---|:---|
| `stockr::get_historic('SAAB-B.ST')` | Ticker symbol(s)[^1] | Daily historic of financial data\* |
| `stockr::get_changes('USD', 'EUR')` | Currencies to convert : from value(s) to value(s) | Latest exchange rates\* |
| `stockr::get_info_from_name('Saab')` | Free-text(s), e.g., company name(s) | Ticker symbol(s) and companie(s) that match the text searched, and latest financial insights<sup>†</sup> |
| `stockr::get_indices()` |  | Major world financial indices and their actual values<sup>‡</sup> |

Sources : <br>\* : Yahoo Finance API, e.g.,
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

swed_indices <- stockr::get_info_from_name(names = c("SAAB", "VOLVO"))

str(swed_indices) # Results of the day, over all marketplaces
#> 'data.frame':    16 obs. of  7 variables:
#>  $ symbol    : chr  "SAAB-B.ST" "SAABY" "SDV1.F" "SAABBS.XC" ...
#>  $ name      : chr  "SAAB AB ser. B" "Saab AB" "Saab AB                       N" "Saab AB" ...
#>  $ last price: chr  "404.30" "20.14" "37.65" "404.00" ...
#>  $ sector    : chr  "Industrials" "Industrials" "Industrials" "Industrials" ...
#>  $ type      : chr  "Stocks" "Stocks" "Stocks" "Stocks" ...
#>  $ exchange  : chr  "STO" "PNK" "FRA" "CXE" ...
#>  $ searched  : chr  "SAAB" "SAAB" "SAAB" "SAAB" ...
```

If you don’t know the ticker symbol of a financial value,
`stockr::get_info_from_name` is a way to retrieving it.

**Get historical financial data.** Given ticker symbol(s), get historic
of financial values with `stockr::get_historic` :

``` r

# Fetch historical values, given ticker symbol(s)
histo <- stockr::get_historic(symbols = c("SAAB-B.ST", "VOLV-B.ST"), .verbose = FALSE)

str(histo)
#> 'data.frame':    12818 obs. of  15 variables:
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
#>  - attr(*, "get.date")= Date[1:1], format: "2025-03-28"
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "min.date")= POSIXct[1:1], format: "2000-01-03 09:00:00"
#>  - attr(*, "max.date")= POSIXct[1:1], format: "2025-03-27 17:29:58"
```

Each lines of this `data.frame` are daily values.

**Change currencies** See Vignette of
[`stockr::get_changes()`](https://clement-lvd.github.io/stockr/articles/Get_changes.html)

[^1]: <https://en.wikipedia.org/wiki/Ticker_symbol>
