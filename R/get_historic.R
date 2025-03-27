#' Fetch historical financial data indices
#'
#' Given indices names (i.e. ticker symbol), the function retrieves historical stock market data
#' from finance.yahoo.com. Answer a `data.frame` with standardized colnames.
#'
#' @param symbols `character` A character string representing the financial indices to search for, e.g., ticker symbol(s).
#' @param wait.time `double`, default = `0` A character string representing an additional waiting time between 2 calls to the Yahoo API.
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console.
#' @param ... Parameters passed to `get_yahoo_data`
#' @inheritDotParams get_yahoo_data
#' @inherit get_yahoo_data return
#' @details
#' Return a `data.frame` (see returned columns in 'Value' section) with additional attributes :
#'  - `symbols`: the symbols originally asked by the user
#'  - `date`: the date when data are retrieved
#'  - `currencies`: the currencies within the `data.frame`
#'  - `n.currencies`: the number of currencies within the `data.frame`
#'  - `min.date`: lowest (ancient) date-value within the `data.frame`
#'  - `max.date`: maximum (recent) date-value within the `data.frame`
#' @examples
#' datas <- get_historic(symbols = c("VOLCAR-B.ST", "SAAB-B.ST") )
#'
#' @seealso \code{\link{get_yahoo_data}}
#' @export
get_historic <- function(symbols = c("SAAB-B.ST"), wait.time = 0, .verbose = T, ...){

  if(!internet_or_not()) return(NA)

   n_operations = length(symbols) # pour un compteur : le n opérations à faire

  if(.verbose) cat("\n=>", n_operations, "request(s) to Yahoo Finance (ETA : ", ( (wait.time + 0.3) * n_operations  ) ,  " sec')" )

  result_actions = list()

stocks <- lapply(symbols, FUN = function(symbol) {

  results <- get_yahoo_data(symbol, ...)
# if only one result and it's a na : return na
if(length(results) == 1){ if(is.na(results)) return(NA) }

    results <- as.data.frame(results)

     Sys.sleep(wait.time)

if(.verbose){ cat("\r"); cat(' ', symbol, "[OK]", rep(" ", 50))}

    return(results)

    })

   returned_results <- do.call(rbind, stocks)
   if(.verbose){cat("\r"); cat(rep(" ", 40))}


if(is.null(returned_results)) return(NULL) #other problem such as no symbol at all or no internet
if( all(is.na(returned_results))) return(NA)

   currencies = unique(returned_results$currency)

   returned_results <- structure(returned_results
                                 , symbols = symbols
                                 , get.date = Sys.Date()
                                 , currencies = currencies
                                 ,  n.currencies = length(currencies)
                                 ,min.date = min(returned_results$date)
                                 ,max.date = max(returned_results$date)

                                 )
   return(returned_results)
}
