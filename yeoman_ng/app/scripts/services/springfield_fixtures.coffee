@app.service 'SpringfieldFixtures', (Springfield, $http) ->

  $http.get '/fixtures/springfield_titles.json'
  .then (resp) =>
    @titles = _.map resp.data, (t) => new Springfield.Title t.name, t.url


  $http.get '/fixtures/springfield_seasons.json'
  .then (resp) =>
    @seasons = _.map resp.data, (s) =>
      new Springfield.Season s.seasonNumber
                           , _.map s.episodes, (e) ->
                               new Springfield.Episode e.name, e.url, e.episodeNumber


  $http.get '/fixtures/springfield_subtitles.json'
  .then (resp) =>
    @subtitles = resp.data.data

  @
