# Helper functions ----

#' Set API key as option
#'
#' \code{set_api_key} sets the musixmatch API key as an option.
#'
#' @param api_key character. API key obtained from \url{https://developer.musixmatch.com/signup}.
#'
#' @return Nothing.
#'
#' @examples
#' \dontrun{
#' set_api_key(YOUR_API_KEY)
#' }
#'
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
#'
#' @noRd
get_content <- function(query_url) {
  query_resp <- httr::GET(query_url, httr::user_agent(UA))

  # TODO: Check for JSON repsonse
  httr::http_type(query_resp)

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

#' Construct API path to append to URL
#'
#' \code{api_path} is a small helper function used to construct query URLs
#'
#' @param path character. Path of API endpoint.
#'
#' @return API_PATH combined with path
#'
#' @noRd
api_path <- function(path) {
  paste0(API_PATH, path)
}

build_api_url <- function(path, query) {
  api_key <- options("rmusix_api_key")[[1]]
  if (is.null(api_key)) {
    stop("API key not found. Please run set_api_key(YOUR_API_KEY).",
         call. = FALSE)
  }

  query$apikey <- api_key
  query$format <- API_FORMAT

  query_url <- httr::modify_url(API_URL,
                                path = api_path(path),
                                query = query)

  query_url
}

# Global package variables ----
API_URL <- "https://api.musixmatch.com/"
API_PATH <- "ws/1.1/"
API_FORMAT <- "json"
UA <- "https://github.com/blairj09/rmusix"
