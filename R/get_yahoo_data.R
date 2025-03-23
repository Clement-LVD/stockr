#' Get Yahoo Finance Data for a Given Symbol
#'
#' Given the symbol of a financial value, this function retrieves historical financial data from Yahoo Finance
#'  and answer a `data.frame` of historical values.
#'  The data includes open stock price, high, low, close, volume, and adjusted close prices, along with timestamps (i.e. the day associated with the measures).
#'
#' The default `data.frame` have a line for each day.
#' If the user provide another interval range than '1d' (one day), lines will be filtered out, in order to match the desired interval range.
#'  Valid interval ranges are: "1d", "5d", "1mo", "3mo", "6mo", "1y", "2y", "5y", "10y", "ytd", and "max".
#'
#' The function allows the user to specify a date range using start and end dates. If no date range is specified,
#' it retrieves all available data from the beginning of time (default for start) to the current date (default for end).
#'
#' @param symbol A character string representing the symbol for the financial instrument (e.g., "AAPL" for Apple).
#' @param start_date A character string representing the start date in the format "YYYY-MM-DD". If `NULL`, data starts from 1970-01-01.
#' @param end_date A character string representing the end date in the format "YYYY-MM-DD". If `NULL`, data is retrieved up to the current date.
#' @param interval A character string representing the interval for the returned datas : default will return daily values.
#' Other intervals will filter out some of these daily values, depending on the desired interval.
#' Valid interval are "1d", "5d", "1mo", "3mo", "6mo", "1y", "2y", "5y", "10y", "ytd", and "max".
#'
#' @return A data frame containing the historical financial data with the following columns:
#'   \item{volume}{`integer` The traded volume.}
#'   \item{high}{`numeric` The highest price for the period (default is each day).}
#'   \item{open}{`numeric` The opening price for the period (default is each day).}
#'   \item{low}{`numeric` The lowest price for the period (default is each day).}
#'   \item{close}{`numeric` The closing price for the period (default is each day).}
#'   \item{adjclose}{`numeric` The adjusted closing price on the period, which accounts for corporate actions like dividends and stock splits.}
#'   \item{timestamp}{`integer` Unix timestamps corresponding to each data point.}
#'   \item{date}{`POSIXct` The day of the financial data point.}
#'   \item{currency}{The currency in which the data is reported, depending on the marketplace.}
#'   \item{symbol}{The stock or financial instrument symbol (e.g., "AAPL").}
#'   \item{longname}{The full name of the company or financial instrument.}
#'   \item{shortname}{The abbreviated name of the company or financial instrument.}
#'   \item{exchangename}{The name of the exchange marketplace where the financial instrument is listed.}
#'   \item{fullexchangename}{The full name of the exchange marketplace.}
#'   \item{timezone}{The timezone in which the data is reported.}
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode
#' @examples
#'   data <- get_yahoo_data(symbol = "SAAB-B.ST", start_date = "2020-01-01", interval = "5d")
#'   head(data)#'
#'   invalid_datas <- get_yahoo_data(symbol ="SAAB" )
#'   invalid_datas
#' @export
get_yahoo_data <- function(symbol = "AAPL", start_date = NULL, end_date = NULL, interval = "1d") {

  if(length(symbol) > 1){
    symbol <- symbol[[1]]
warning(immediate. = T, "Only one symbol should be passed and you have indicated several !
\nOnly the 1st of these symbols will be considered, i.e. ", symbol)
  }

  valid_ranges <- c( "1d" , "5d" , "1mo", "3mo" ,"6mo" ,"1y"  ,"2y" , "5y" , "10y", "ytd","max")
  if(!interval %in% valid_ranges){
    stop("Specified interval ('",interval, "') is not a valid range. \nChoices are : ", paste0(collapse= ", ", valid_ranges ))
  }

   # Si les dates sont spécifiées, les convertir en timestamps Unix
  if (!is.null(start_date)) {
    start_timestamp <- as.integer(as.POSIXct(start_date, tz = "UTC"))
  } else {
    start_timestamp <- 0  # 0 timestamp is the default (01/01/1970)
  }

  if (!is.null(end_date)) {
    end_timestamp <- as.integer(as.POSIXct(end_date, tz = "UTC"))
  } else {
    end_timestamp <- as.integer(Sys.time())  # today is the default
  }

#### API request ####
  #  construct an api request
  url <- paste0("https://query1.finance.yahoo.com/v8/finance/chart/", symbol)

  # add parameters in a proper list
  params <- list(
    period1 = start_timestamp,
    period2 = end_timestamp,
    interval = interval
  )

  # Create parameters for the yahoo url-api
  query_string <- paste(names(params), params, sep = "=", collapse = "&")
  full_url <- paste(url, "?", query_string, sep = "")
  full_url <- utils::URLencode(full_url)

  # answer readLines raw content
  connection <- tryCatch({
    # Attempt to open the connection
    url(full_url, open = "r")
  }, error = function(e) {
    # If an error occurs, print a message and return NULL
    cat("Error: ", e$message, "\n")
    return(NULL) # no internet or other scenario
  }, warning = function(w) {
    warning_message <- w$message
    if(grep(x = warning_message, "404 Not Found")){return(NA)}
    # a warning is most of the times an error answered by the api # cat("Warning: ", w$message, "\n")
    return(NULL) # non existent value
  })

  if(is.na(connection)) {warning(immediate. = T,
                                 "The value is not associated with a valid currency name !\n=> "
                                 , symbol, " is not a valid name, according to the Yahoo Finance API.
See : https://finance.yahoo.com/ for valid names")
    return(NA)
  }

  if(is.null(connection)) return(NULL) # It's certainly a default from the user (e.g., no internet or no proxy)

  response_text <- readLines(connection, warn = F)

  close(connection)

# the API query1.finance.yahoo.com/V8 answer JSON
  # Convert JSON to a list
  data <- jsonlite::fromJSON(paste(response_text, collapse = ""))

  #### data wrangling ####
  # deal with historical indicators list
indicators <- data$chart$result$indicators
quote_data <- indicators$quote[[1]]

quote_data<-append(quote_data, data$chart$result$indicators$adjclose[[1]] )

df_historical_values <-  data.frame(lapply(quote_data, unlist))
# add timestamp
df_historical_values$timestamp <- data$chart$result$timestamp[[1]]
df_historical_values$date <- as.POSIXct(df_historical_values$timestamp)

# and the overall datas interesting for us :
meta_datas <- data$chart$result$meta


col_to_add <- meta_datas[, c("currency", "symbol",  "shortName" , "exchangeName", "fullExchangeName","timezone")]
 # "regularMarketPrice" is redundant with the ADJUSTED (!) price at closing time or the opening

df_historical_values <- data.frame( df_historical_values,  col_to_add, check.names = FALSE, row.names = NULL)
# lot of redundancy but that's okaysh for the sake of limiting errors and misunderstood
colnames(df_historical_values) <- tolower(colnames(df_historical_values))

return(unique(df_historical_values))
}
