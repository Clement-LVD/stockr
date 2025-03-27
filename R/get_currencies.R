#' Fetch Financial currencies Names
#'
#' This function fetches a table of financial indices (currencies) from Yahoo Finance.
#' Optionally, it can filter the results to include only the specified indices.
#'
#' @param keep A character vector of symbols to filter the results. If NULL (default),
#'                  no filtering is applied, and all available indices are returned.
#'
#' @return A data frame containing unique financial indices (currencies). The table has
#'         columns like `symbol`, `name`, and other relevant information, with all column names in lowercase.
#'         If `keep` is specified, only the matching indices are returned.
#'
#' @details The function sends a request to Yahoo Finance's API to fetch a list of available currencies.
#'          It then processes the results and returns them as a data frame. If an internet connection is not available,
#'          a warning message is shown.
#'
#' @examples
#' # Fetch all available indices
#' all_indices <- get_currencies()
#'
#' # Fetch only specific indices
#' selected_indices <- get_currencies(keep = c("USD", "EUR"))
#'
#' @export
get_currencies <- function(keep = NULL) {


  if(!internet_or_not()) return(NA)

  url <- retrieve_yahoo_api_chart_url(suffix = "v1/finance/currencies")
  # url <- "https://query1.finance.yahoo.com/"

currencies <- fetch_yahoo_api(url)

if(is.null(currencies) | is.na(currencies)) return(currencies)

    results <- currencies$currencies$result

    # filter indices
    if(!is.null(keep) ) {results <- results[which(results$symbol  %in% keep), ]}

    colnames(results) <- tolower(colnames(results))

    return(unique(results))
  }
