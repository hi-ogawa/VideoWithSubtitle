@app.service 'SpringfieldWrapper', (Springfield) ->

  @titles           = []
  @titlesLoading    = false
  @seasons          = []
  @seasonsLoading   = false
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

  @
