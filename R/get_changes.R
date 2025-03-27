#' Get Exchange Rates from Yahoo Finance, Given Devises
#'
#' This function retrieves exchange rates for a given currency pair. Default convert to USD ($)
#' Source is Yahoo Finance API. It returns a `data.frame` with daily exchange rate data.
#' Returned `data.frame` is historical values on a day and latest insights within attributes
#' Returned values are supposed to be each minute within a day, more or less (≃ 1200 obs. ± 200 obs.).
#'
#' @param from, default = `NULL` A character string representing the base currency (e.g., "USD").
#' @param to, default = `"USD"` A character string representing the target currency (e.g., "EUR").
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
#'   \item{currency}{`character`, the base currency.}
#'   \item{symbol}{`character`, the Yahoo Finance symbol (e.g., "EURUSD=X").}
#'   \item{exchange_name}{`character`, the exchange place name, i.e. CCY for currencies.}
#'   \item{regularmarketprice}{`numeric`, the latest market price.}
#'   \item{regularmarketdayhigh}{`numeric`, the market highest price of this day.}
#'   \item{regularmarketdaylow}{`numeric`, the market lowest price of this day.}
#'   \item{fifty_two_week_high}{`numeric`, the highest price in the last 52 weeks.}
#'   \item{fifty_two_week_low}{`numeric`, the lowest price in the last 52 weeks.}
#'   \item{previous_close}{`numeric`, the last closing price.}
#'   \item{timezone}{`character`, the market's timezone.}
#'   \item{date}{`POSIXct` Equivalent to the timestamp of `regularmarketprice`, date of the observation.}
#'   \item{from}{`character`, the currency converted into another, e.g., if the `from` value is 1$ ('USD'), you want to receive a certain amount of the other currency to reach 1$.}
#'   \item{to}{`character`, the currency that you want to convert into : **all the `numeric` values (not `integer`) in this line of the `data.frame` are expressed with this currency**.}

#' }
#'
#' @examples
#' # Fetch exchange rate data for USD to EUR
#' df <- get_changes(from = c("USD", "EUR"), to = "RON")
#' # Convert USD & EUR to Romanian Leu (RON)
#' head(df)
#' # or pass like a named list of character
#' df2 <- get_changes(from = c("EUR" = "RON", "USD" = "EUR"))
#' # Or indicate paired values as 2 list :
#' same_as_df2 <- get_changes(from = c("EUR", "USD"), c("RON" , "EUR"))
#' # Access metadata attributes
#' attr(df, "insights")
#' @export
get_changes <- function(from = NULL, to = "USD"){
# User have to indicate currencies to get_changes()

if(is.null(from)) return(NULL)

if(!internet_or_not()) return(NULL)

  if(length(names(from)) > 0){to = from ; from = names(from)}

 # User have to pass a list of equal lenght or only one element
  if(all(length(from) != length(to), length(from) > 1, length(to) > 1) ) {return(NA)}
  # here we have maybe a list of equal lenght, or only one value to translate for other

  # ask for exchanges rates from the standard API url
  url =  retrieve_yahoo_api_chart_url()
  url = paste0(url, from, to, '=X')
# multiply url according to paste() behavior
 changes <- lapply(url, get_a_change)

changes <- do.call(rbind, changes)
if(all(sapply(changes, is.na) )) return(NA)

# tweak columns : date
changes$date <- as.POSIXct(changes$regularmarkettime)
changes$from = from
changes$to = to

return(changes)
}

# non - vectorized func for a couple
get_a_change <- function(url, return_historic = F){

  currencies <- fetch_yahoo_api(  url  )[[1]]

  if(length(currencies) == 1 ) if(is.na(currencies)) return(NA)

  #we have results. Extract main info :
  main <- data.frame(currencies$result)

#we have results. Extract main info :
main <- data.frame(currencies$result)

lengs <- sapply(main$meta,  FUN = function(cell) length(cell))
listt <- sapply(main$meta, is.list)

global_changes <- data.frame(main$meta[lengs == 1 & !listt])

meta_tables <- main$meta[lengs > 1][[1]] #1st object with length > 1 !
# it's several df with values (timestamp)
dataframe_meta <- lapply(names(meta_tables), FUN = function(name){
tble <-  as.data.frame(meta_tables[[name]])
colnames(tble) <- paste0(name, "_", colnames(tble))
tble
}
  )

dataframe_meta <- do.call(cbind,dataframe_meta)

global_changes <- cbind(global_changes, dataframe_meta)

colnames(global_changes) <- tolower(colnames(global_changes))
# global_changes$convert <- gsub("\\=X", "", global_changes$symbol)

if(!return_historic) return(global_changes) # if the user want historic

  #extract time.series info
  time.list <- main$indicators$quote[[1]]

  time.currencies <- do.call(cbind, lapply(time.list, unlist))

  historic <- data.frame(timestamp = main$timestamp[[1]],  rate = time.currencies)

  historic$date <- as.POSIXct(historic$timestamp)
  #unify tables
  structure(historic, insights = global_changes)

}
