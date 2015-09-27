@app.service 'SpringfieldWrapper', (Springfield) ->

  @titles           = []
  @titlesLoading    = false
  @title            = null
  @seasons          = []
  @seasonsLoading   = false
  @season           = null
  @episode          = null
  @subtitles        = ""
  @subtitlesLoading = false
  @searchingQs      = []

  @search = (query) =>
    @titlesLoading = true
    p = Springfield.search query
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

  @getSubtitles = (episode) =>
    unless episode then return
    @episode = episode
    @subtitles = ""
    @subtitlesLoading = true
    episode?.getSubtitles()
    .then (subtitles) =>
      @subtitles = subtitles
      @subtitlesLoading = false
    .catch =>
      @subtitlesLoading = false
      throw ""

  @
