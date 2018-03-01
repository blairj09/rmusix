#' Get albums for a specific artist
#'
#' \code{get_artist_albums} returns all the albums for a given artist and details
#' about each album.
#'
#' @references \url{https://developer.musixmatch.com/documentation/api-reference/artist-albums-get}
#'
#' @param artist_id numeric. Musixmatch artist id.
#' @param artist_mbid character. Musicbrainz artist id. Defaults to NULL.
#' @param group_by numeric. Group by album name.
#' @param sort character. Sort by album release date. Either ascending (asc)
#'   or descending (desc).
#' @param page numeric. Page of results to return. Defaults to 1.
#' @param page_size numeric. Number of results per page. Defaults to 50.
#'
#' @return A tibble of album details for the provided artist.
#'
#' @examples
#' \dontrun{
#' # Get all of Taylor Swift's albums
#' get_artist_albums(259675)
#' }
#'
#' @export
get_artist_albums <- function(artist_id,
                              artist_mbid = NULL,
                              group_by = 1,
                              sort = c("desc", "asc"),
                              page = 1,
                              page_size = 50) {
  query_url <- build_api_url(path = "artist.albums.get",
                             query = list(
                               artist_id = artist_id,
                               artist_mbid = artist_mbid,
                               g_album_name = group_by,
                               s_release_date = match.arg(sort),
                               page = page,
                               page_size = page_size
                             ))

  query_cont <- get_content(query_url)

  album_tbl <- query_cont %>%
    purrr::pluck("message", "body", "album_list", "album") %>%
    dplyr::select(
      album_id,
      album_mbid,
      album_name,
      album_rating,
      album_track_count,
      album_release_date,
      album_release_type,
      artist_id,
      artist_name,
      album_copyright,
      album_label,
      updated_time
    ) %>%
    tibble::as_tibble() %>%
    dplyr::mutate(
      album_release_date = as.Date(album_release_date)
    ) %>%
    purrr::map_df(readr::parse_guess)

  album_tbl
}

