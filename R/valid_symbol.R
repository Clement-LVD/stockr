#' Validate Financial Symbols via Yahoo Finance API
#'
#' This function checks the validity of one or multiple financial symbols using Yahoo Finance's validation API.
#' It returns a table of boolean values indicating whether each symbol is recognized by Yahoo Finance.
#'
#' @param symbols `character` A string or a list of character strings representing financial symbols to validate.
#' @param .verbose `logical` If TRUE, messages are displayed when invalid symbols are detected. Default is TRUE.
#'
#' @return A boolean table with one row and as many columns as the number of symbols provided by the user.
#' Each column corresponds to a symbol, with TRUE if Yahoo Finance recognizes the symbol, and FALSE otherwise.
#' Returns NA if the input is not a character.
#'
#' @examples
#' valid_symbol("AAPL")
#' valid_symbol(c("AAPL", "GOOGL", "INVALID"))
#'
#' @export
valid_symbol <- function(symbols = NULL, .verbose = T) {

  if(!is.character(symbols)) {
    message("You have passed a ", class(symbols), " object. Provide characters - single value or list - to valid_symbol()")
    return(NA)}

  if(length(symbols) > 1) symbols <- paste0(symbols, collapse = ",")
  symbols <- gsub(" *", "", symbols, perl = T )

   url <- paste0('https://query2.finance.yahoo.com/v6/finance/quote/validate?symbols=', symbols)

  clean_url <- utils::URLencode(url)

  if (!internet_or_not()) {message("No internet access.") ; return(NULL) }

  results <- fetch_yahoo_api(clean_url)

  # table with one entry per symbols
  validity <- results$symbolsValidation$result

  if(any(validity == F)) if(.verbose) message("Invalid financial symbol(s) : ", paste0(colnames(validity)[validity == F] , collapse = ", ") )

  return(validity)

}
