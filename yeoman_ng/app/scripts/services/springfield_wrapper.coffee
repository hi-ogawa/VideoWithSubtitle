@app.service 'SpringfieldWrapper', (Springfield, promiseTracker) ->

  @lastQuery        = null
  @titles           = []
  @titlesTracker    = promiseTracker()

  @title            = null
  @season           = null
  @episode          = null


  @search = (query) =>
    @lastQuery = query
    p = Springfield.search query
        .catch         => throw ""
        .then (titles) =>
          if @lastQuery is query
            @titlesTracker.cancel()
            @titles = titles
    @titlesTracker.addPromise p


  @setTitleInitSeasons = (t) =>
    @title   = t
    @episode = null
    @title.fetchSeasons()
    .then =>
      @season = @title.seasons[0]


  @setEpisodeInitSubtitles = (e) =>
    @episode = e
    @episode.fetchSubtitles()

  @
