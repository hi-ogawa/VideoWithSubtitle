@app.service "TvonlineWrapper", (Tvonline, promiseTracker, $rootScope) ->

  @lastQuery        = null
  @titles           = []
  @titlesTracker    = promiseTracker()

  @title            = null
  @season           = null
  @episode          = null
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


  @setTitleInitSeasons = (t) =>
    @title   = t
    @episode = null
    @video   = null
    @title.fetchSeasons()
    .then =>
      @season = @title.seasons[0]


  @setEpisodeInitVideos = (e) =>
    @episode = e
    @video   = null
    @episode.fetchVideos()

  @
