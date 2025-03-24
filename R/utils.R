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


#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode
fetch_yahoo_api <- function(url, symbol){

  url <- utils::URLencode(url)

  # answer readLines raw content
  connection <- tryCatch({
    # Attempt to open the connection
    url(url, open = "r")
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

  if(is.na(connection)) {   return(NA)  }

  if(is.null(connection)) return(NULL) # It's certainly a default from the user (e.g., don't pass the good value)

  response_text <- readLines(connection, warn = F)

  close(connection)

  data <- jsonlite::fromJSON(paste(response_text, collapse = ""))

  return(data)
}


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


fetch_yahoo_tables <- function(url, return_all = F){

  url_complete <- utils::URLencode(url)
  # 1) read webpage HTML
  page_source <- readLines(url_complete, warn = FALSE)
  # Concatenate a full HTML page and read any table
  page_html <- paste(page_source, collapse = "\n")
  # strict testing of result
  no_result <- grepl(paste0("No results for '"), page_html)

  if(no_result) return(NULL)

  tables <-  XML::readHTMLTable(page_html,  stringsAsFactors = FALSE)

  if(length(tables) == 0) return(NULL)

  # Verify results
  if (!is.null(tables) && length(tables) > 0) {

    if(!return_all) tables  <- tables[[1]]  # get first table

  } else {  return(NULL) }

return(tables)
}

