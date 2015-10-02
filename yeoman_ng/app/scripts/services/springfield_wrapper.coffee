@app.service 'SpringfieldWrapper', (Springfield, promiseTracker) ->

  @lastQuery        = null
  @titles           = []
  @titlesTracker    = promiseTracker()
  @title            = null

  @seasons          = []
  @seasonsTracker   = promiseTracker()
  @season           = null

  @episode          = null
  @subtitles        = null
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
    @clearTitle()
    @title = title
    p = title.getSeasons()
        .catch          => throw ""
        .then (seasons) =>
          if @title is title
            @seasonsTracker.cancel()
            @seasons = seasons
            @season  = seasons[0]
    @seasonsTracker.addPromise p

  @getSubtitles = (episode) =>
    @clearEpisode()
    @episode = episode
    p = episode.getSubtitles()
        .catch            => throw ""
        .then (subtitles) =>
          if @episode is episode
            @subtitlesTracker.cancel()
            @subtitles = subtitles
    @subtitlesTracker.addPromise p

  @clearTitle = =>
    @title   = null
    @seasons = []
    @clearSeason()

  @clearSeason = =>
    @season = null
    @clearEpisode()

  @clearEpisode = =>
    @episode = null
    @subtitles = null

  @
