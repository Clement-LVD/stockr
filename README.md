
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

**Fetch ticker symbol and actual values.** Given a keyword such a
company name, search latest stock values with `stockr::fetch_indices`.

``` r
library(stockr)

toyota_indices <- stockr::fetch_indices(names = "TOYOTA")

str(toyota_indices) # Results of the day, over all marketplaces
#> 'data.frame':    25 obs. of  7 variables:
#>  $ symbol         : chr  "TM" "TOMA.MU" "TAH0.MU" "TOM.VI" ...
#>  $ name           : chr  "Toyota Motor Corporation" "TOYOTA MOTOR CORP.            R" "Toyota Industries Corp.       R" "TOYOTA MOTOR CORP" ...
#>  $ last_price     : chr  "190.70" "178.00" "86.00" "17.61" ...
#>  $ sector_category: chr  "Consumer Cyclical" "Consumer Cyclical" "Industrials" "Consumer Cyclical" ...
#>  $ type           : chr  "Stocks" "Stocks" "Stocks" "Stocks" ...
#>  $ exchange       : chr  "NYQ" "MUN" "MUN" "VIE" ...
#>  $ searched       : chr  "TOYOTA" "TOYOTA" "TOYOTA" "TOYOTA" ...
```

Typically, you start by retrieving an exact ticker symbol using
`stockr::fetch_indices` or another way. You can then use these ticker
symbols to fetch the corresponding historical financial data (see
below).

**Fetch historical financial data.**

``` r

# Fetch historical values, given ticker symbol(s)
histo <- stockr::fetch_historic(symbols = c("SAAB-B.ST", "VOLV-B.ST"), .verbose = FALSE)

str(histo)
#> 'data.frame':    12810 obs. of  14 variables:
#>  $ low             : num  16.9 16.4 17.1 17.1 16.5 ...
#>  $ open            : num  18.5 17.7 17.1 17.1 16.5 ...
#>  $ high            : num  18.5 17.7 17.1 17.1 17 ...
#>  $ volume          : int  313414 294565 0 0 313418 264509 165960 205163 151425 214397 ...
#>  $ close           : num  17.4 17.1 17.1 17.1 16.9 ...
#>  $ adjclose        : num  9.86 9.66 9.66 9.66 9.53 ...
#>  $ timestamp       : int  946886400 946972800 947059200 947145600 947232000 947491200 947577600 947664000 947750400 947836800 ...
#>  $ date            : POSIXct, format: "2000-01-03 09:00:00" "2000-01-04 09:00:00" ...
#>  $ currency        : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol          : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ shortname       : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ exchangename    : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename: chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone        : chr  "CET" "CET" "CET" "CET" ...
#>  - attr(*, "fetch.symbols")= chr [1:2] "SAAB-B.ST" "VOLV-B.ST"
#>  - attr(*, "fetch.date")= Date[1:1], format: "2025-03-23"
#>  - attr(*, "fetch.currencies")= chr "SEK"
#>  - attr(*, "n.currencies")= int 1
```

This historical `data.frame` contain daily value.

**Chaining examples 1 & 2.** Fetch ticker symbols associated with a
keyword such as companies names, and get historical financial data for
these symbols.

``` r
# 1) fetch_indices (optionally filter a precise marketplace)
indices <- stockr::fetch_indices(names = c("VOLVO", "SAAB", "TOYOTA")
                         , marketplaces = "BER")
# Keep only the german marketplace (BERlin) informations

# 2) Fetch historical values, given ticker symbol(s)
datas <- stockr::fetch_historic(symbols = indices$symbol)
#> 
#> => 6 request(s) to Yahoo Finance (ETA :  1.5  sec')  VOL3.BE [OK]                                                                                                      VOL1.BE [OK]                                                                                                      SDV0.BE [OK]                                                                                                      SDV1.BE [OK]                                                                                                      TAH.BE [OK]                                                                                                      TOM.BE [OK]                                                                                                    

str(datas)
#> 'data.frame':    31223 obs. of  14 variables:
#>  $ low             : num  4.94 4.9 4.74 4.7 4.7 ...
#>  $ volume          : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ open            : num  4.94 4.9 4.74 4.7 4.7 ...
#>  $ high            : num  4.94 4.9 4.74 4.7 4.76 ...
#>  $ close           : num  4.94 4.9 4.74 4.7 4.76 ...
#>  $ adjclose        : num  0.000575 0.000571 0.000552 0.000547 0.000554 ...
#>  $ timestamp       : int  946882800 946969200 947055600 947142000 947228400 947487600 947574000 947660400 947746800 947833200 ...
#>  $ date            : POSIXct, format: "2000-01-03 08:00:00" "2000-01-04 08:00:00" ...
#>  $ currency        : chr  "EUR" "EUR" "EUR" "EUR" ...
#>  $ symbol          : chr  "VOL3.BE" "VOL3.BE" "VOL3.BE" "VOL3.BE" ...
#>  $ shortname       : chr  "Volvo (publ), AB              N" "Volvo (publ), AB              N" "Volvo (publ), AB              N" "Volvo (publ), AB              N" ...
#>  $ exchangename    : chr  "BER" "BER" "BER" "BER" ...
#>  $ fullexchangename: chr  "Berlin" "Berlin" "Berlin" "Berlin" ...
#>  $ timezone        : chr  "CET" "CET" "CET" "CET" ...
#>  - attr(*, "fetch.symbols")= chr [1:6] "VOL3.BE" "VOL1.BE" "SDV0.BE" "SDV1.BE" ...
#>  - attr(*, "fetch.date")= Date[1:1], format: "2025-03-23"
#>  - attr(*, "fetch.currencies")= chr "EUR"
#>  - attr(*, "n.currencies")= int 1
```

## Technical details

### Sources

| Function | Source |
|:---|:---|
| `stockr::fetch_indices()` | Scraping from <https://finance.yahoo.com/lookup/> |
| `stockr::fetch_historic()` | Fetch from Yahoo API |

### Returned data.frame philosophy

The `stockr` functions (`fetch_historic` & `fetch_indices`) returns a
standardized `data.frame` containing financial data from the Yahoo
Finance API.

- The returned data is always in the form of a `data.frame` object.

- The variable names in the returned `data.frame` are consistent and
  inherited directly from the Yahoo Finance API, although they are
  converted to lowercase.

- Dependencies are keep at a minimal and no data analysis package
  dependencies are imposed on the user : no assumptions are made about
  the analysis tools you’ll used (e.g., no dependencies on `zoo` or
  `xts` for time series analysis since `stockr` does not return time
  series objects).

[^1]: <https://en.wikipedia.org/wiki/Ticker_symbol>
