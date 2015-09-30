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
    @title   = title
    @seasons = []
    @season  = null
    @episode = null
    @videos  = []
    @video   = null
    p = title.getSeasons()
        .catch          => throw ""
        .then (seasons) =>
          @seasonsTracker.cancel()
          @seasons = seasons
          @season  = seasons[0]
    @seasonsTracker.addPromise p

  @getVideos = (episode) =>
    @episode = episode
    @videos  = []
    @video   = null
    p = episode.getVideos()
        .catch         => throw ""
        .then (videos) =>
          if @episode is episode
            @videosTracker.cancel()
            @videos = videos
    @videosTracker.addPromise p

  @
