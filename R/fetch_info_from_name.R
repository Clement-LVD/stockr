#' Fetch latest global stock information and ticker symbol, based on company name(s)
#'
#' Given companies names, the function retrieves overall stock market data
#' (by performing scraping on https://finance.yahoo.com ).
#' It returns a data frame with the ticker symbol on various exchange
#' , companies names, last price on the marketplace,
#' sector/category (if available), type (e.g., "stocks")
#' , exchange marketplace name and initially searched companies names.
#'
#' @param names A character string representing the company name to search for.
#' @param exchange (optionnal) A character string representing the exchange place(s) to consider (exact match). Default keep all the exchange places.
#' @param sector (optionnal)  A character string representing the sector(s) to consider (exact match). Default keep all results.
#' @return A data frame with columns:
#' 	- `symbol`: The stock ticker symbol from yahoo
#' 	- `name`: The full company name.
#' 	- `last_price`: The latest available price.
#' 	- `sector`: The sector or industry category (if available).
#' 	- `type`: The type of asset (certainly "stocks").
#' 	- `exchange`: The stock exchange place for this stock.
#'  - `searched`: The original names searched
#' @examples
#' oil <- fetch_info_from_name(names = c("TOTAL", "SHELL", "BP"), sector = "Energy")
#'
#' #Get data on marketplace(s)
#' swedish <- fetch_info_from_name(names = c("SAAB", "VOLVO"),  exchange = c("STO", "PAR"))
#' @seealso \code{\link{get_yahoo_data}},  \code{\link{fetch_historic}}
#' @importFrom XML readHTMLTable
#' @importFrom utils URLencode
#' @export
fetch_info_from_name <- function(names, exchange = NULL, sector = NULL) {

  if(!internet_or_not()) return(NA)

 # loop over the names#
results <- lapply(names, function(name) {

base_url = "https://finance.yahoo.com/lookup/equity/?s="
url_complete <- paste0(base_url, name)
# fetch yahoo data
     table <-  fetch_yahoo_tables(url_complete)
if(!is.list(table)) return(NULL)
  table$searched <- name
     return(table)
        })

results <- do.call(rbind, results)

colnames(results) <- trimws(tolower(colnames(results)))
colnames(results)[grep("sector", colnames(results) )] <- "sector"

if(!is.null(sector)) results <- results[which(results$sector %in% sector), ]

# filter exchange
if(!is.null(exchange) ) {results <- results[which(results$exchange %in% exchange), ]}

return(unique(results))
}



