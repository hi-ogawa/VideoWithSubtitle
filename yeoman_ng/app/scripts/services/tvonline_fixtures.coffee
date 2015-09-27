@app.service 'TvonlineFixtures', (Tvonline, $http) ->

  $http.get '/fixtures/tvonline_titles.json'
  .then (resp) =>
    @titles = _.map resp.data, (t) => new Tvonline.Title t.name, t.url


  $http.get '/fixtures/tvonline_seasons.json'
  .then (resp) =>
    @seasons = _.map resp.data, (s) =>
      new Tvonline.Season s.seasonNumber
                        , _.map s.episodes, (e) ->
                            new Tvonline.Episode e.name, e.url, e.episodeNumber


  $http.get '/fixtures/tvonline_videos.json'
  .then (resp) =>
    @videos = _.map resp.data, (e) => new Tvonline.Video e.name, e.url

  @
