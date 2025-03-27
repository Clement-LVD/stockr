#' Retrieve Stock Market Indices from Yahoo Finance
#'
#' This function fetches real-time stock market indices, including price, change, and percentage change, from Yahoo Finance.
#'
#' @return A data frame with the following columns:
#'   \item{symbol}{Character. The ticker symbol of the index (e.g., `^GSPC` for S&P 500).}
#'   \item{name}{Character. The full name of the index (e.g., "S&P 500").}
#'   \item{price}{`numeric`  The current value of the index.}
#'   \item{change}{`numeric` The absolute change in index value.}
#'   \item{change_percent}{`numeric` The percentage change in index value.}
#'
#' @examples
#' \dontrun{
#' indices <- get_indices()
#' head(indices)
#' }
#'
#' @export
get_indices <- function(){

if(!internet_or_not()) return(NULL)

url = "https://finance.yahoo.com/markets/world-indices/"
indices <- fetch_yahoo_tables(url, open_mode = 'rb')

if(is.null(indices)) return(NULL)

# eject col without char :
n.char.col <- apply(indices, 2, FUN = function(col) sum(nchar(col)) )
n.char.col <- names(n.char.col)[n.char.col == 0]

indices[, n.char.col] <- NULL

colnames(indices) <- gsub(" \\%", "_percent", colnames(indices))

colnames(indices) <- trimws(colnames(indices))
indices$volume <- NULL

# extract values !
before_sign = sub("(-|\\+|\\.00\\().*", "", indices$price) # extract before '-' or '+'

indices$price <- as.numeric(gsub(",", "", before_sign))  # remove ','

return(indices)

}

