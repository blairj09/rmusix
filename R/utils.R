# Helper functions ----

#' Set API key as option
#' @export
set_api_key <- function(api_key) {
  options(rmusix_api_key = api_key)
}

# Internal functions ----


# Global package variables ----
API_URL <- "https://api.musixmatch.com/ws/1.1/"
API_FORMAT <- "json"
