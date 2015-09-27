@app.service "TvonlineWrapper", (Tvonline) ->

  @titles           = []
  @titlesLoading    = false
  @seasons          = []
  @seasonsLoading   = false
  @videos           = []
  @videosLoading    = false
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
          throw "TvonlineWrapper.search error"

    @searchingQs.push p

  @
