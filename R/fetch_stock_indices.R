#' Fetch stock indices based on a company name
#'
#' Given companies names, the function retrieves overall stock market data
#' (by searching on https://finance.yahoo.com ).
#' It returns a data frame with the stock symbol on various marketplaces
#' , companies names, last price on the marketplace,
#' sector/category (if available), type (always "stocks")
#' , exchange marketplace name and initially searched companies names.
#'
#' @param names A character string representing the company name to search for.
#' @param marketplaces (optionnal) A character string representing the marketplace(s) to consider. Default keep all the marketplace
#' @return A data frame with columns:
#' 	- `Symbol`: The stock ticker symbol from yahoo
#' 	- `Name`: The full company name.
#' 	- `Last Price`: The latest available price.
#' 	- `Sector / Category`: The sector or industry category (if available).
#' 	- `Type`: The type of asset (always "stocks").
#' 	- `Exchange`: The stock exchange place for this stock.
#'  - `searched`: The original names searched
#' @examples
#' fetch_stock_indices(names = c("VOLVO", "SAAB"),  marketplaces = "STO"  )
#' @importFrom XML readHTMLTable
#' @importFrom utils URLencode
#' @export
fetch_stock_indices <- function(names, marketplaces = NULL) {
base_url = "https://finance.yahoo.com/lookup/equity/?s="
  #0-A) construire une url valide

  # Construire l'URL de recherche avec encodage des accents et espaces
  name_encode <- URLencode(names)
  url_complete <- paste0(base_url, name_encode)

  if(length(names) > 1) { #ON VA REMPLIR L'OBJET LISTE_TOTALE


      # sinon c'est plus compliqué car il faut rbind tous les résultats ^^
      results <- do.call(rbind, lapply(names, function(name) {
        # Appeler la fonction pour chaque terme et renvoyer le résultat
        fetch_stock_indices(name)
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

return(unique(table))
}



