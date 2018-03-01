#' Get all tracks from a given album
#'
#' \code{get_album_tracks} returns a tibble of all tracks and associated details
#'   for a given album.
#'
#' @references \url{https://developer.musixmatch.com/documentation/api-reference/album-tracks-get}
#'
#' @param album_id numeric. Musixmatch album id.
#' @param album_mbid character. Musicbrainz album id. Defaults to NULL.
#' @param has_lyrics logical. Only return tracks with lyrics? Defaults to TRUE.
#' @param page numeric. The page number to return for paginated results. Defaults
#'   to 1.
#' @param page_size numeric. The number of results to return per page. Defaults
#'   to 25.
#'
#' @return A tibble containing tracks from the given album.
#'
#' @examples
#' \dontrun{
#' # Get tracks from Taylor Swift's reputation album
#' get_album_tracks(26806100)
#' }
#'
#' @export
get_album_tracks <- function(album_id,
                             album_mbid = NULL,
                             has_lyrics = TRUE,
                             page = 1,
                             page_size = 25) {
  query_url <- build_api_url(path = "album.tracks.get",
                             query = list(
                               album_id = album_id,
                               album_mbid = album_mbid,
                               f_has_lyrics = has_lyrics,
                               page = page,
                               page_size = page_size
                             ))

  query_cont <- get_content(query_url)

  track_tbl <- query_cont %>%
    purrr::pluck("message", "body", "track_list", "track") %>%
    dplyr::select(
      artist_id,
      artist_name,
      album_id,
      album_name,
      track_id,
      track_name,
      track_rating,
      track_length,
      commontrack_id,
      instrumental,
      explicit,
      has_lyrics,
      has_lyrics_crowd,
      has_subtitles,
      has_richsync,
      num_favourite,
      lyrics_id,
      subtitle_id,
      first_release_date,
      updated_time
    ) %>%
    tibble::as_tibble() %>%
    purrr::map_df(readr::parse_guess) %>%
    mutate(
      album_name = as.character(album_name)
    )

  track_tbl
}

#' Get lyrics for a given track
#'
#' \code{get_track_lyrics} returns a tibble of lyrics and lyric metadata for a
#'   given track. Note that currently the free API plan from Musixmatch only
#'   returns 30% of available lyrics.
#'
#' @references \url{https://developer.musixmatch.com/documentation/api-reference/track-lyrics-get}
#'
#' @param track_id numeric. Musixmatch track id.
#' @param commontrack_id numeric. Musixmatch commontrack id. Defaults to NULL.
#'
#' @return A tibble containing lyrics and lyric metadata for the requested track.
#'
#' @examples
#' \dontrun{
#' # Get lyrics for ...Ready for it by Taylor Swift
#' get_track_lyrics(134319902)
#' }
#'
#' @export
get_track_lyrics <- function(track_id, commontrack_id = NULL) {
  query_url <- build_api_url(path = "track.lyrics.get",
                             query = list(
                               track_id = track_id,
                               commontrack_id = commontrack_id
                             ))

  query_cont <- get_content(query_url)

  message(query_cont[["message"]][["body"]][["lyrics"]][["lyrics_copyright"]])

  lyrics_list <- query_cont %>%
    purrr::pluck("message", "body", "lyrics")

  lyrics_tbl <- lyrics_list[purrr::map_chr(lyrics_list, ~class(.)[1]) != "list"] %>%
    tibble::as_tibble() %>%
    dplyr::select(
      lyrics_id,
      lyrics_body,
      lyrics_language,
      explicit,
      dplyr::contains("tracking_url"),
      updated_time
    ) %>%
    purrr::map_df(readr::parse_guess)

  lyrics_tbl
}
