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

  ) #fin du trycatch
return(test)
}  # fin de fonction internet_or_not
