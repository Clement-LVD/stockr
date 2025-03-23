#' Fetch historical financial data indices
#'
#' Given indices names (i.e. ticker symbol), the function retrieves historical stock market data
#' from finance.yahoo.com. Answer a `data.frame` with standardized colnames.
#'
#' @param symbols `character` A character string representing the indices to search for.
#' @param wait.time `double` A character string representing the indices to search for.
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console.
#' @param ... Parameters passed to `get_yahoo_data` such as the `interval` between two lines, a start_date or end_date
#' @return A data frame with columns:
#' 	- `low`: Lowest value of the indice during this day.
#' 	- `high`: Highest value of the indice during this day.
#' 	- `close`: Value at the closing of the maketplace.
#' 	- `open`: The value at the opening of the marketplace
#' 	- `volume`: The volume of operation.
#' 	- `adjclose`: The adjusted closing value.
#'  - `timestamp`: The date for these values
#'  - `date`: The date for these values
#'  - `symbol`: The original indices names searched
#'  - `shortname`: The name of the value
#'  - `exchangename`: The financial place abbreviation
#'  - `fullexchangename`: The full name of the financial place
#'  - `timezone`: The timezone, e.g., 'CET' for Central European Time
#'
#'  This `data.frame` have additional attributes :
#'  - `fetch.symbols`: the symbols originally asked by the user
#'  - `fetch.date`: the date when data are retrieved
#'  - `fetch.currencies`: the currencies within the `data.frame`
#'  - `n.currencies`: the number of currencies within the `data.frame`
#' @examples
#' datas <- fetch_historic(symbols = c("VOLCAR-B.ST", "SAAB-B.ST") )
#' @seealso \code{\link{get_yahoo_data}}
#' @export
fetch_historic <- function(symbols = c("SAAB-B.ST"), wait.time = 0, .verbose = T, ...){

  n_operations = length(symbols) # pour un compteur : le n opérations à faire

  if(.verbose) cat("\n=>", n_operations, "request(s) to Yahoo Finance (ETA : ", ( (wait.time + 0.25) * n_operations  ) ,  " sec')" )

  result_actions = list()

stocks <- lapply(symbols, FUN = function(symbol) {
    results <- get_yahoo_data(symbol, ...)

    results <-   as.data.frame(results)

     Sys.sleep(wait.time)

if(.verbose){ cat("\r"); cat(' ', symbol, "[OK]", rep(" ", 50))}

    return(results)

    })

   returned_results <- do.call(rbind, stocks)
   if(.verbose){cat("\r"); cat(rep(" ", 50))}


if(is.null(returned_results)) return(NULL) #other problem such as no symbol at all or no internet

   currencies = unique(returned_results$currency)
   returned_results <- structure(returned_results
                                 ,  fetch.symbols = symbols
                                 , fetch.date = Sys.Date()
                                 , fetch.currencies = currencies
                                 ,  n.currencies = length(currencies)
                                 )

   return(returned_results)
}
