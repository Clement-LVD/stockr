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
#'   \item{open}{`numeric` The opening price for the period (default is each day).}
#'   \item{close}{`numeric` The closing price for the period (default is each day).}
#'   \item{adjclose}{`numeric` The adjusted closing price on the period, which accounts for corporate actions like dividends and stock splits.}
#'   \item{low}{`numeric` The lowest price for the period (default is each day).}
#'   \item{high}{`numeric` The highest price for the period (default is each day).}
#'   \item{volume}{`integer` The traded volume.}
#'   \item{timestamp}{`integer` Unix timestamps corresponding to each data point.}
#'   \item{date}{`POSIXct` The day of the financial data point.}
#'   \item{currency}{`character` The currency in which the data is reported, depending on the marketplace.}
#'   \item{symbol}{`character` The stock or financial instrument symbol (e.g., "AAPL").}
#'   \item{shortname}{`character` The abbreviated name of the company or financial instrument.}
#'   \item{longname}{`character` The full name of the company or financial instrument.}
#'   \item{exchangename}{`character` The name of the exchange marketplace where the financial instrument is listed.}
#'   \item{fullexchangename}{`character` The full name of the exchange marketplace.}
#'   \item{timezone}{`character` The timezone in which the data is reported.}
#' @examples
#'
#'   data <- get_yahoo_data(symbol = "SAAB-B.ST", start_date = "2020-01-01", interval = "5d")
#'   head(data)
#'
#' @export
get_yahoo_data <- function(symbol = "AAPL", start_date = NULL, end_date = NULL, interval = "1d") {

  if(length(symbol) > 1) message("You have to provide only one ticker symbol")

  if(!all(valid_symbol(symbol))){ return(NA) }

  if(length(symbol) > 1){
    symbol <- symbol[[1]]
warning(immediate. = T, "Only one symbol should be passed and you have indicated several.
\nOnly the 1st of these symbols will be considered, i.e. ", symbol)
  }

  valid_ranges <- c( "1d" , "5d" , "1mo", "3mo" ,"6mo" ,"1y"  ,"2y" , "5y" , "10y", "ytd","max")
  if(!interval %in% valid_ranges){
    stop("Specified interval ('",interval, "') is not a valid range. \nChoices are : ", paste0(collapse= ", ", valid_ranges ))
  }

   # convert date to timestamps Unix
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
  #  construct an api request : standard API url
  url <- paste0(retrieve_yahoo_api_chart_url(), symbol)

  # add parameters in a proper list
  params <- list(
    period1 = start_timestamp,
    period2 = end_timestamp,
    interval = interval
  )

  # Create parameters for the yahoo url-api
  query_string <- paste(names(params), params, sep = "=", collapse = "&")
  full_url <- paste(url, "?", query_string, sep = "")

  # fetch data
    data <- fetch_yahoo_api(full_url)


  #### data wrangling ####
  # deal with historical indicators list
indicators <- data$chart$result$indicators
quote_data <- indicators$quote[[1]]

quote_data <- append(quote_data, data$chart$result$indicators$adjclose[[1]] )

df_historic <-  data.frame(lapply(quote_data, unlist))

col_to_retain <- c("open","close" ,"adjclose" ,"low" , "high" , "volume" )
# add fake col
df_historic <- add_missing_var_to_df(df = df_historic, col_to_retain)

df_historic <- df_historic[ , col_to_retain ]

# add timestamp
df_historic$timestamp <- data$chart$result$timestamp[[1]]
df_historic$date <- as.POSIXct(df_historic$timestamp)

# and the overall datas interesting for us :
meta_datas <- data$chart$result$meta

to_retain <-  c("currency", "symbol",  "shortName" , "longName", "exchangeName", "fullExchangeName","timezone")
meta_datas <- add_missing_var_to_df(df = meta_datas, to_retain)

col_to_add <- meta_datas[, to_retain]
 # "regularMarketPrice" is redundant with the ADJUSTED (!) price at closing time or the opening

df_historic <- data.frame( df_historic,  col_to_add, check.names = FALSE, row.names = NULL)
# lot of redundancy but that's okaysh for the sake of limiting errors and misunderstood
colnames(df_historic) <- tolower(colnames(df_historic))

return(unique(df_historic))
}
