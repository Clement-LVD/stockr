#' Fetch historical financial data indices
#'
#' Given indices names, the function retrieves historical stock market data
#' (from finance.yahoo.com by default). Answer a `data.frame` with standardized colnames.
#'
#' @param symbols `character` A character string representing the indices to search for.
#' @param wait.time `double` A character string representing the indices to search for.
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console
#' @return A data frame with columns:
#' 	- `open`: The value at the opening of the marketplace
#' 	- `high`: Highest value of the indice during this day.
#' 	- `low`: Lowest value of the indice during this day.
#' 	- `close`: Value at the closing of the maketplace.
#' 	- `volume`: The volume of operation.
#' 	- `adjusted`: The adjusted closing value.
#'  - `symbol`: The original indices names searched
#'  - `date`: The date for these values
#' @examples
#' datas <- fetch_historic(symbols = c("VOLCAR-B.ST", "SAAB-B.ST") )
#' @seealso \code{\link{get_yahoo_data}}
#' @export
fetch_historic <- function(symbols = c("SAAB-B.ST"), wait.time = 0, .verbose = T){

  n_operations = length(symbols) # pour un compteur : le n opérations à faire

  if(.verbose) cat("\n=>", n_operations, "request(s) to Yahoo Finance (ETA : ", ( (wait.time + 0.25) * n_operations  ) ,  " sec')" )

  result_actions = list()

stocks <- lapply(symbols, FUN = function(symbol) {
    results <- get_yahoo_data(symbol)

    results <-   as.data.frame(results)

     Sys.sleep(wait.time)

if(.verbose){ cat("\r"); cat(' ', symbol, "[OK]", rep(" ", 50))}

    return(results)

    })

   returned_results <- do.call(rbind, stocks)
   if(.verbose){cat("\r"); cat(rep(" ", 50))}
   return(returned_results)
}
