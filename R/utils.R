# url of yahoo api is from here. Default is V8 API
retrieve_yahoo_api_chart_url <- function(suffix = "v8/finance/chart/"){return(paste0("https://query1.finance.yahoo.com/", suffix) )}

# utility function : add a var full of na, given a list of vars
add_missing_var_to_df <- function(df, vars, .verbose = T){

  col_to_retain <- vars
  # add fake col
  missing_col <- setdiff(col_to_retain, colnames(df) )
  if(length(missing_col) > 0){
   if(.verbose) warning("\nMissing var' from the Yahoo API have been filled with NA values (i.e. ", paste0(missing_col, collapse = ", "), ")")
     df[ , missing_col] <- NA
  }
  return(df)
}

# check if the user have internet
internet_or_not <- function(url_to_ping = "https://www.google.com", timeout = 2) {
  old_timeout <- getOption("timeout")

  options(timeout = timeout)
  on.exit(options(timeout = old_timeout))

test <-  tryCatch({
    con <- url(url_to_ping, open = "r")
     close(con)
    return(TRUE)

  }, error = function(e) {
    # En cas d'erreur (au bout de 2 sec. donc)

    FALSE

  }, warning = function(w){
    # hypothèse : un warning est pour dire "pas d'accès à google.fr" dans ce cas !

    FALSE
  }

  ) #end trycatch
if(!test) warning("No Internet connection. Please check your network")

return(test)
}


# yahoo finance API answer json :
#' @importFrom jsonlite fromJSON
fetch_yahoo_api <- function(url){

  response_text <- try_url(url, open_mode = "r")

  data <- jsonlite::fromJSON(paste(response_text, collapse = ""))

  return(data)
}

# some page a gzip raw content :s
# url = "https://finance.yahoo.com/markets/world-indices/"
# open_mode = 'rb'
# table <- fetch_yahoo_tables(url, open_mode = 'rb')
# some pages are good old html data
fetch_yahoo_tables <- function(url, return_all = F, open_mode = "r"){

  page_html <- try_url(url,open_mode = open_mode)

  # strict testing of result
  no_result <- grepl(paste0("No results for '"), page_html)

  if(no_result) return(NULL)

  tables <- extract_html_tables(page_html, return_all = F)

  if(is.data.frame(tables) ) colnames(tables) <- tolower(colnames(tables))

return(tables)
}

#' @importFrom XML readHTMLTable
extract_html_tables <- function(content, return_all = F){

  tables <-  XML::readHTMLTable(content,  stringsAsFactors = FALSE)

  if(length(tables) == 0) return(NULL)

  # Verify results
  if (!is.null(tables) && length(tables) > 0) {

    if(!return_all) tables  <- tables[[1]]  # get first table

  } else {  return(NULL) }

  return(tables)

}
