#' Fetch stock indices with `quantmod`
#'
#' Given indices names, the function retrieves historical stock market data
#' (from finance.yahoo.com by default).
#' It returns the data frame returned by quantmod::getSymbols
#'  with a proper date column, standardized colnames.
#'
#' @param symbols `character` A character string representing the indices to search for.
#' @param wait.time `double` A character string representing the indices to search for.
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console
#' @param src `character`, default = `'yahoo'` The src parameters of  quantmod::getSymbols.
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
#' @seealso \url{https://www.quantmod.com/documentation/getSymbols.html}
#' @importFrom quantmod getSymbols
#' @export
fetch_historic <- function(symbols = c("SAAB-B.ST"), wait.time = 0,.verbose = T, src = "yahoo"){

  n_operations = length(symbols) # pour un compteur : le n opérations à faire

  if(.verbose) cat("ETA : ", ( (wait.time + 0.25) * n_operations  ) ,  " sec'\n" )

  result_actions = list()

stocks <- lapply(symbols, FUN = function(action) {

    results <- quantmod::getSymbols(action,  auto.assign = F, src = src, verbose = .verbose )

    results <-   as.data.frame(results)
# quantmod is full of for loop and never return the same colnames, always with maj. :s
    colnames(results) <- tolower(gsub(x = colnames(results), pattern = paste0(action, "\\."), replacement = "" ) )
    # we have lowered the colnames
    results$symbol <- action
    results$date <- rownames(results)

     Sys.sleep(wait.time)

    return(results)
    })

   returned_results <- do.call(rbind, stocks)

   return(returned_results)
}
