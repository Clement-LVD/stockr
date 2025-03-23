
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stockr

<!-- badges: start -->
<!-- badges: end -->

`stockr` is a R package that provide stock datas, given companies names.

## Installation

You can install the development version of stockr like so:

``` r
devtools::install_github("clement-LVD/stockr")
```

## Example

``` r
library(stockr)
#> Registered S3 method overwritten by 'quantmod':
#>   method            from
#>   as.zoo.data.frame zoo
# get indices names on the swedish marketplace
indices <- fetch_stock_indices(names = c("VOLVO", "SAAB") , marketplaces = "STO")
# search for historical values
datas <- fetch_historic(symbols = indices$symbol )
#> ETA :  1  sec'
#> downloading  VOLCAR-B.ST .....
#> 
#> downloading  VOLV-A.ST .....
#> 
#> downloading  VOLV-B.ST .....
#> 
#> downloading  SAAB-B.ST .....
```
