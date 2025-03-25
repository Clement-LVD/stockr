#' Fetch Historical Exchange Rates from Yahoo Finance
#'
#' This function retrieves historical exchange rates for a given currency pair
#' from Yahoo Finance and returns a dataframe with daily exchange rate data
#' (values are supposed to be each precise minute of the same day).
#'
#' @param from A character string representing the base currency (e.g., "USD").
#' @param to A character string representing the target currency (e.g., "EUR").
#'
#' @return A dataframe with daily exchange rates. The returned dataframe contains the following columns:
#' \describe{
#'   \item{timestamp}{int, the timestamp of the rate.}
#'   \item{rate.high}{Numeric, the highest exchange rate of the day.}
#'   \item{rate.low}{Numeric, the lowest exchange rate of the day.}
#'   \item{rate.open}{Numeric, the opening exchange rate of the day.}
#'   \item{rate.volume}{Numeric, the trading volume for the day.}
#'   \item{rate.close}{Numeric, the closing exchange rate of the day.}
#'   \item{date}{POSIXct, the corresponding date (YYYY-MM-DD).}
#' }
#'
#' @details
#' The function also returns an additional `insights` `data.frame` as attributes.
#' Some of the key attributes include latest informations from Yahoo Finance API :
#' \describe{
#'   \item{currency}{Character, the base currency.}
#'   \item{symbol}{Character, the Yahoo Finance symbol (e.g., "EURUSD=X").}
#'   \item{exchange_name}{Character, the exchange place name.}
#'   \item{regular_market_price}{Numeric, the latest market price.}
#'   \item{regularmarketdayhigh}{Numeric, the market highest price of this day.}
#'   \item{regularmarketdaylow}{Numeric, the market lowest price of this day.}
#'   \item{fifty_two_week_high}{Numeric, the highest price in the last 52 weeks.}
#'   \item{fifty_two_week_low}{Numeric, the lowest price in the last 52 weeks.}
#'   \item{previous_close}{Numeric, the last closing price.}
#'   \item{timezone}{Character, the market's timezone.}
#'   \item{range}{Character, the data range (e.g., "1d", "5d", "1mo").}
#' }
#'
#' @examples
#' # Fetch exchange rate data for USD to EUR
#' df <- fetch_changes("USD", "EUR")
#'
#' # View the first few rows of the dataframe
#' head(df)
#'
#' # Access metadata attributes
#' attr(df, "insights")
#' @export
fetch_changes <- function(from, to ){

  if(!internet_or_not()) return(NA)

  url =  'https://query1.finance.yahoo.com/v8/finance/chart/'
  url = paste0(url, from, to, '=X')
  currencies <- fetch_yahoo_api(  url  )[[1]]

  #main info :
  main <- data.frame(currencies$result)

 lengs <- sapply(main$meta,  FUN = function(cell) length(cell))

global_changes <- data.frame(main$meta[lengs == 1])

global_changes <- cbind(global_changes, main$meta[lengs > 1][[1]])

colnames(global_changes) <- tolower(colnames(global_changes))

#time.series info
time.list <- main$indicators$quote[[1]]

time.currencies <- do.call(cbind, lapply(time.list, unlist))

historic <- data.frame(timestamp = main$timestamp[[1]],  rate = time.currencies)

historic$date <- as.POSIXct(historic$timestamp)

# 3) unify tables
structure(historic, insights = global_changes)

}
