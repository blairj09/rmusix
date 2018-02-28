# Helper functions ----

#' Set API key as option
#' @export
set_api_key <- function(api_key) {
  options(rmusix_api_key = api_key)
}

# Internal functions ----
#' Get content from query_url
#'
#' \code{get_content} takes a query URL and returns the parsed content after
#'   checking for errors.
#'
#' @param query_url string. Url to be queried.
#'
#' @return Parsed content of the query_url.
#' @noRd
get_content <- function(query_url) {
  query_resp <- httr::GET(query_url)

  # Extract and parse content
  query_cont <- httr::content(query_resp, type = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  # Check for errors
  status_code <- query_cont[["message"]][["header"]][["status_code"]]
  if (status_code != 200) {
    stop("API returned status code ",
         status_code,
         ". See https://developer.musixmatch.com/documentation/status-codes for additional details",
         call. = FALSE)
  }

  query_cont
}

# Global package variables ----
API_URL <- "https://api.musixmatch.com/ws/1.1/"
API_FORMAT <- "json"
