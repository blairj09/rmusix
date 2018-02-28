#' Search for a specific artist
#'
#' \code{search_artists} searches for a specific artist and returns data that
#' appears to match.
#'
#' @references \url{https://developer.musixmatch.com/documentation/api-reference/artist-search}
#'
#' @param artist string. The name of the artist to search for.
#' @param page numeric. The page number to return for paginated results.
#'   Defaults to 1.
#' @param page_size numeric. The number of results to display per page. Defaults
#'   to 10.
#'
#' @return A tibble containing details about matches to the artist searched for.
#' @export
search_artists <- function(artist, page = 1, page_size = 10) {
  query_url <- httr::modify_url(API_URL,
                                path = "ws/1.1/artist.search",
                                query = list(
                                  format = API_FORMAT,
                                  q_artist = artist,
                                  page = page,
                                  page_size = page_size,
                                  apikey = options("rmusix_api_key")
                                )
  )

  query_resp <- httr::GET(query_url)

  query_cont <- httr::content(query_resp, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  artist_tbl <- query_cont %>%
    purrr::pluck("message", "body", "artist_list", "artist") %>%
    dplyr::select(
      artist_id,
      artist_name
    ) %>%
    tibble::as_tibble()

  artist_tbl
}

#' Get details about a specific artist
#'
#' \code{get_artist} returns details about a specific artist.
get_artist <- function(artist_id, artist_mbid = NULL) {
  query_url <- httr::modify_url(API_URL,
                                path = "ws/1.1/artist.get",
                                query = list(
                                  artist_id = artist_id,
                                  artist_mbid = artist_mbid,
                                  apikey = options("rmusix_api_key")
                                ))

  query_resp <- httr::GET(query_url)

  query_cont <- httr::content(query_resp, type = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()
}

# get_related_artists

# get_chart_artists
