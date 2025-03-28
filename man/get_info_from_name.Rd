% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_info_from_name.R
\name{get_info_from_name}
\alias{get_info_from_name}
\title{Fetch latest global stock information and ticker symbol, based on company name(s)}
\usage{
get_info_from_name(names, exchange = NULL, sector = NULL)
}
\arguments{
\item{names}{A character string representing the company name to search for.}

\item{exchange}{(optionnal) A character string representing the exchange place(s) to consider (exact match). Default keep all the exchange places.}

\item{sector}{(optionnal)  A character string representing the sector(s) to consider (exact match). Default keep all results.}
}
\value{
A data frame with columns:
- \code{symbol}: The stock ticker symbol from yahoo
- \code{name}: The full company name.
- \code{last_price}: The latest available price.
- \code{sector}: The sector or industry category (if available).
- \code{type}: The type of asset (certainly "stocks").
- \code{exchange}: The stock exchange place for this stock.
\itemize{
\item \code{searched}: The original names searched
}
}
\description{
Given companies names, the function retrieves overall stock market data
(by performing scraping on https://finance.yahoo.com ).
It returns a data frame with the ticker symbol on various exchange
, companies names, last price on the marketplace,
sector/category (if available), type (e.g., "stocks")
, exchange marketplace name and initially searched companies names.
}
\examples{
oil <- get_info_from_name(names = c("TOTAL", "SHELL", "BP"), sector = "Energy")

#Get data on marketplace(s)
swedish <- get_info_from_name(names = c("SAAB", "VOLVO"),  exchange = c("STO", "PAR"))
}
\seealso{
\code{\link{get_yahoo_data}},  \code{\link{get_historic}}
}
