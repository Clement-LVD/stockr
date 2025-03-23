#' Fetch ticker stock indices based on a company name
#'
#' Given companies names, the function retrieves overall stock market data
#' (by searching on https://finance.yahoo.com ).
#' It returns a data frame with the ticker symbol on various marketplaces
#' , companies names, last price on the marketplace,
#' sector/category (if available), type (always "stocks")
#' , exchange marketplace name and initially searched companies names.
#'
#' @param names A character string representing the company name to search for.
#' @param marketplaces (optionnal) A character string representing the marketplace(s) to consider. Default keep all the marketplace
#' @return A data frame with columns:
#' 	- `symbol`: The stock ticker symbol from yahoo
#' 	- `name`: The full company name.
#' 	- `last_price`: The latest available price.
#' 	- `sector_category`: The sector or industry category (if available).
#' 	- `type`: The type of asset (always "stocks").
#' 	- `exchange`: The stock exchange place for this stock.
#'  - `searched`: The original names searched
#' @examples
#' \donttest{
#' fetch_indices(names = c("VOLVO", "SAAB"),  marketplaces = "STO")
#' }
#' @seealso \code{\link{get_yahoo_data}},  \code{\link{fetch_historic}}
#' @importFrom XML readHTMLTable
#' @importFrom utils URLencode
#' @export
fetch_indices <- function(names, marketplaces = NULL) {

  if(!internet_or_not()) warning("No Internet connection. Please check your network")

base_url = "https://finance.yahoo.com/lookup/equity/?s="

  name_encode <- utils::URLencode(names)
  url_complete <- paste0(base_url, name_encode)

  if(length(names) > 1) { #ON VA REMPLIR L'OBJET LISTE_TOTALE


      # sinon c'est plus compliqué car il faut rbind tous les résultats ^^
      results <- do.call(rbind, lapply(names, function(name) {
        # Appeler la fonction pour chaque terme et renvoyer le résultat
        fetch_indices(name)
      }))

if(!is.null(marketplaces) ) {results <- results[which(results$exchange %in% marketplaces), ]}

      # Afficher le résultat final
      return(unique(results))


    } else name = names

# LA FONCTION PROPREMENT DITE COMMENCE ICI
# 1) Lire la page web

  # Lire le contenu HTML de la page web
  page_source <- readLines(url_complete, warn = FALSE)
  # Coller les lignes ensemble pour reformer le HTML complet
  page_html <- paste(page_source, collapse = "\n")
tables <-  XML::readHTMLTable(page_html,  stringsAsFactors = FALSE)

# Vérifier ce qui a été extrait
if (!is.null(tables) && length(tables) > 0) {
  table  <- tables[[1]]  # Première table
  table$searched <- name
} else {
  table  <- NULL
}

colnames(table) <- trimws(tolower(colnames(table)))
colnames(table) <- gsub(x = colnames(table), " / | ", "_")
return(unique(table))
}



