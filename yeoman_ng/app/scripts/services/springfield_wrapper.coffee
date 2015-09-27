@app.service 'SpringfieldWrapper', (Springfield) ->

  @titles      = []
  @seasons     = []
  @subtitles   = ""
  @searchingQs = []

  @search = (query) =>
    p = Springfield.search query
        .then (titles) =>
           if _.last(@searchingQs) is p
             @titles = titles
    @searchingQs.push p

  @
