@app.service 'Springfield', (promiseTracker, Yql) ->

  _baseUrl = "http://www.springfieldspringfield.co.uk"


  # String -> [Title]
  @search = (query) ->

    Yql.getHTML "#{_baseUrl}/tv_show_episode_scripts.php?search=#{encodeURIComponent(query)}"
    .then (JQhtml) ->

      JQhtml.find('.script-list-item').map ->
        name = $(this).text()
        url  = _baseUrl + $(this).attr('href')
        new Title name, url
      .toArray()


  @Title =
  class Title   # String, String
    constructor: (@name,  @url) ->
      # [Season]
      @seasons        = null
      @seasonsTracker = promiseTracker()
      @seasonsP       = null

    # -> promise of [Season]
    fetchSeasons: ->
      return @seasonsP if @seasonsP # throw real request only the first time

      @seasonsP =
        Yql.getHTML @url
        .then (JQhtml) =>

          quadruples =
            JQhtml.find('.season-episode-title').map ->
              href    = $(this).attr('href')
              {
                name         : $(this).text().match(/\-\ (.*)$/)[1]
                url          : _baseUrl + "/" + href
                seasonNumber : parseInt href.match(/\&episode\=s(\d*)/)[1]
                episodeNumber: parseInt href.match(/\&episode\=s\d*e(\d*)/)[1]
              }
            .toArray()

          @seasons =
            _(quadruples)
            .groupBy (q) -> q.seasonNumber
            .pairs()
            .map (seasonNumber_episodes) ->
              new Season parseInt(seasonNumber_episodes[0])
                        , _.map seasonNumber_episodes[1], (q) ->
                            new Episode q.name, q.url, q.episodeNumber
            .value()
      @seasonsTracker.addPromise @seasonsP
      @seasonsP


  @Season =
  class Season  # Number,         [Episode]
    constructor: (@seasonNumber, @episodes) ->


  @Episode =
  class Episode # String, String, Number
    constructor: (@name,  @url,   @episodeNumber) ->
      @subtitles        = null
      @subtitlesTracker = promiseTracker()
      @subtitlesP       = null

    # -> promise of (Html) String
    fetchSubtitles: ->
      return @subtitlesP if @subtitlesP

      @subtitlesP =
        Yql.getHTML @url
        .then (JQhtml) =>

          @subtitles =
            JQhtml.find("div.scrolling-script-container").html().split("<br>")
                  .map((s) -> "<span> #{s.replace(/(\t|\n|\r)/gm, "").trim()} </span>")
                  .join("<br>")
      @subtitlesTracker.addPromise @subtitlesP
      @subtitlesP

  @
