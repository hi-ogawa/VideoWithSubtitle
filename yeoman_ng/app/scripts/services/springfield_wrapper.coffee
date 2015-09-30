@app.service 'SpringfieldWrapper', (Springfield, promiseTracker) ->

  @lastQuery        = null
  @titles           = []
  @titlesTracker    = promiseTracker()
  @title            = null

  @seasons          = []
  @seasonsTracker   = promiseTracker()
  @season           = null

  @episode          = null
  @subtitles        = ""
  @subtitlesTracker = promiseTracker()

  @search = (query) =>
    @lastQuery = query
    p = Springfield.search query
        .catch         => throw ""
        .then (titles) =>
          if @lastQuery is query
            @titlesTracker.cancel()
            @titles = titles
    @titlesTracker.addPromise p

  @getSeasons = (title) =>
    @title     = title
    @seasons   = []
    @season    = null
    @episode   = null
    @subtitles = ""
    p = title.getSeasons()
        .catch          => throw ""
        .then (seasons) =>
          if @title is title
            @seasonsTracker.cancel()
            @seasons = seasons
            @season  = seasons[0]
    @seasonsTracker.addPromise p

  @getSubtitles = =>
    @subtitles = ""
    p = @episode.getSubtitles()
        .catch            => throw ""
        .then (subtitles) =>
          @subtitlesTracker.cancel()
          @subtitles = subtitles
    @subtitlesTracker.addPromise p

  @
