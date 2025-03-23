
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

toyota_indices <- fetch_indices(names = "TOYOTA")

str(toyota_indices) # Results of the day, over all marketplaces
#> 'data.frame':    25 obs. of  7 variables:
#>  $ symbol           : chr  "TM" "TOMA.MU" "7203.T" "TAH0.MU" ...
#>  $ name             : chr  "Toyota Motor Corporation" "TOYOTA MOTOR CORP.            R" "TOYOTA MOTOR CORP" "Toyota Industries Corp.       R" ...
#>  $ last price       : chr  "190.70" "178.00" "2,844.50" "86.00" ...
#>  $ sector / category: chr  "Consumer Cyclical" "Consumer Cyclical" "Consumer Cyclical" "Industrials" ...
#>  $ type             : chr  "Stocks" "Stocks" "Stocks" "Stocks" ...
#>  $ exchange         : chr  "NYQ" "MUN" "JPX" "MUN" ...
#>  $ searched         : chr  "TOYOTA" "TOYOTA" "TOYOTA" "TOYOTA" ...
```

Typically, you start by retrieving the exact ticker symbol using
`stockr::fetch_indices`. For example, Toyota’s stock on the ‘NYQ’ is
identified by the ticker symbol ‘TM’. You can then use these symbols to
fetch the corresponding historical financial data (see below).

**Fetch historical financial data (Yahoo API).**

``` r

# Fetch historical values, given ticker symbol(s)
saab_histo <- fetch_historic(symbols = "SAAB-B.ST", .verbose = FALSE)
#> SAAB-B.ST [OK]

str(saab_histo)
#> 'data.frame':    6405 obs. of  15 variables:
#>  $ volume          : int  313414 294565 0 0 313418 264509 165960 205163 151425 214397 ...
#>  $ high            : num  18.5 17.7 17.1 17.1 17 ...
#>  $ open            : num  18.5 17.7 17.1 17.1 16.5 ...
#>  $ low             : num  16.9 16.4 17.1 17.1 16.5 ...
#>  $ close           : num  17.4 17.1 17.1 17.1 16.9 ...
#>  $ adjclose        : num  9.86 9.66 9.66 9.66 9.53 ...
#>  $ timestamp       : int  946886400 946972800 947059200 947145600 947232000 947491200 947577600 947664000 947750400 947836800 ...
#>  $ date            : POSIXct, format: "2000-01-03 09:00:00" "2000-01-04 09:00:00" ...
#>  $ currency        : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol          : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ longname        : chr  "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" ...
#>  $ shortname       : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ exchangename    : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename: chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone        : chr  "CET" "CET" "CET" "CET" ...
```

**Chaining examples 1 & 2.**

``` r
# 1) fetch_indices (optionally filter a precise marketplace)
indices <- fetch_indices(names = c("VOLVO", "SAAB", "TOYOTA")
                         , marketplaces = "BER")
# Keep only the german marketplace (BERlin) informations

# 2) Fetch historical values, given ticker symbol(s)
datas <- fetch_historic(symbols = indices$symbol)
#> 
#> => 6 request(s) to Yahoo Finance (ETA :  1.5  sec')VOL3.BE [OK]                                                                                                    VOL1.BE [OK]                                                                                                    SDV0.BE [OK]                                                                                                    SDV1.BE [OK]                                                                                                    TAH.BE [OK]                                                                                                    TOMA.BE [OK]                                                                                                    

str(datas)
#> 'data.frame':    30951 obs. of  15 variables:
#>  $ high            : num  4.94 4.9 4.74 4.7 4.76 ...
#>  $ volume          : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ low             : num  4.94 4.9 4.74 4.7 4.7 ...
#>  $ open            : num  4.94 4.9 4.74 4.7 4.7 ...
#>  $ close           : num  4.94 4.9 4.74 4.7 4.76 ...
#>  $ adjclose        : num  0.00049 0.000486 0.00047 0.000466 0.000472 ...
#>  $ timestamp       : int  946882800 946969200 947055600 947142000 947228400 947487600 947574000 947660400 947746800 947833200 ...
#>  $ date            : POSIXct, format: "2000-01-03 08:00:00" "2000-01-04 08:00:00" ...
#>  $ currency        : chr  "EUR" "EUR" "EUR" "EUR" ...
#>  $ symbol          : chr  "VOL3.BE" "VOL3.BE" "VOL3.BE" "VOL3.BE" ...
#>  $ longname        : chr  "Volvo AB" "Volvo AB" "Volvo AB" "Volvo AB" ...
#>  $ shortname       : chr  "Volvo (publ), AB              N" "Volvo (publ), AB              N" "Volvo (publ), AB              N" "Volvo (publ), AB              N" ...
#>  $ exchangename    : chr  "BER" "BER" "BER" "BER" ...
#>  $ fullexchangename: chr  "Berlin" "Berlin" "Berlin" "Berlin" ...
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
  object.

- No specific data analysis package dependencies are imposed on the user
  : no assumptions are made about the analysis tools you’ll used (e.g.,
  no dependencies on `zoo` or `xts` for time series analysis since
  `stockr` does not return time series objects).

It is up to the user to create more advanced data analysis objects from
the returned data.
