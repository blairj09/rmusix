get_lyrics <- function(track_id) {
  query_url <- httr::modify_url(API_URL,
                                path = "ws/1.1/track.lyrics.get",
                                query = list(
                                  track_id = track_id,
                                  apikey = options("rmusix_api_key")
                                ))

  query_resp <- httr::GET(query_url)

  query_cont <- httr::content(query_resp, type = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  query_cont
}
