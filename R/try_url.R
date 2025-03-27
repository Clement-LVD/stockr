
# url = "https://finance.yahoo.com/markets/world-indices/"
# need rb reading mode / yahoo api need r reading mode
#  try to reach a page and read content according to the open mode
#' @importFrom utils URLencode
try_url <- function(url, open_mode = "r"){
  if(!open_mode %in% c("r", "rb")) cat("Opening mode are 'r' or 'rb'")
  url <- utils::URLencode(url)

  # answer readLines raw content
  connection <- tryCatch({
    # Attempt to open the connection
    url(url, open = open_mode)
  }, error = function(e) {
    # If an error occurs, print a message and return NULL
    cat("Error: ", e$message, "\n")
    return(NULL) # no internet or other scenario
  }, warning = function(w) {

    if(grepl(x = w$message, "404 Not Found")){return(NA)}
    # a warning is most of the times an error answered by the api
    return(NULL) # non existent value, e.g., '401 Unauthorized' error
  })

  if(is.null(connection)) return(NULL) # It's certainly a mistake from the user (e.g., don't pass the good value)

  if(is.na(connection)) { return(NA)  }


  if(open_mode == "r"){ response_text <- readLines(connection, warn = F) }

  if(open_mode == "rb") {response_raw <- readBin(connection, what = "raw", n = 1e6)  # read binary
  response_text <-  read_gzip_binary_content(response_raw)
  } # func hereafter

  close(connection)
# readlines method interpretate linebreak as several lines
  if( length(response_text) > 1 ) response_text <- paste(response_text, collapse = "\n")

  return(response_text)
}


# for some of the yahoo page we need to unzip a gzip raw data
read_gzip_binary_content <- function(content, encoding = "UTF-8"){

  # uncompress : yahoo send us Gzip raw content
  decompressed <- memDecompress(content, type = "gzip")
  # type = c("unknown", "gzip", "bzip2", "xz", "none"),

  # extract to utf8 char
  text_content <- rawToChar(decompressed)

  # correcting encoding
  Encoding(text_content) <- encoding

  return(text_content)

}
