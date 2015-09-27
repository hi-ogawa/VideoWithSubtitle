@app.service "TvonlineWrapper", (Tvonline) ->

  @titles           = []
  @titlesLoading    = false
  @title            = null
  @seasons          = []
  @seasonsLoading   = false
  @season           = null
  @episode          = null
  @videos           = []
  @videosLoading    = false
  @video            = null
  @searchingQs      = []

  @search = (query) =>
    @titlesLoading = true
    p = Tvonline.search query
        .then (titles) =>
          if _.last(@searchingQs) is p
            @titlesLoading = false
            @titles = titles
        .catch =>
          @titlesLoading = false
          throw ""

    @searchingQs.push p

  @getSeasons = (title) =>
    if @seasonsLoading then return
    @seasons = []
    @season  = null
    @title   = title
    @seasonsLoading = true
    title.getSeasons()
    .then (seasons) =>
      @seasonsLoading = false
      @seasons = seasons
      @season  = seasons[0]
    .catch =>
      @titlesLoading = false
      throw ""

  @getVideos = (episode) =>
    if @videosLoading then return
    @videos  = []
    @video   = null
    @episode = episode
    @videosLoading = true
    episode.getVideos()
    .then (videos) =>
      @videos = videos
      @videosLoading = false
    .catch =>
      @videosLoading = false
      throw ""
  @
