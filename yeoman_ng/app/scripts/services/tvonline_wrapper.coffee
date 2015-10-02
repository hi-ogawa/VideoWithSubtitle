@app.service "TvonlineWrapper", (Tvonline, promiseTracker) ->

  @lastQuery        = null
  @titles           = []
  @titlesTracker    = promiseTracker()
  @title            = null

  @seasons          = []
  @seasonsTracker   = promiseTracker()
  @season           = null

  @episode          = null
  @videos           = []
  @videosTracker    = promiseTracker()
  @video            = null

  @search = (query) =>
    @lastQuery = query
    p = Tvonline.search query
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
          @seasonsTracker.cancel()
          @seasons = seasons
          @season  = seasons[0]
    @seasonsTracker.addPromise p

  @getVideos = (episode) =>
    @clearEpisode()
    @episode = episode
    p = episode.getVideos()
        .catch         => throw ""
        .then (videos) =>
          if @episode is episode
            @videosTracker.cancel()
            @videos = videos
    @videosTracker.addPromise p

  @clearTitle = =>
    @title   = null
    @seasons = []   # @title has many @seasons
    @clearSeason()

  @clearSeason = =>
    @season = null
    @clearEpisode()

  @clearEpisode = =>
    @episode = null
    @videos  = []   # @episode has many @videos
    @video   = null

  @
