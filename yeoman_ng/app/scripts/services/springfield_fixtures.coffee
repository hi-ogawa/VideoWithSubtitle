@app.service 'SpringfieldFixtures', (Springfield, $http) ->

  $http.get '/fixtures/springfield_titles.json'
  .then (resp) =>
    @titles = _.map resp.data, (t) => new Springfield.Title t.name, t.url


  $http.get '/fixtures/springfield_episodes.json'
  .then (resp) =>
    @episodes = _.map resp.data, (e) => new Springfield.Episode e.name, e.url, e.season, e.episode


  $http.get '/fixtures/springfield_subtitles.json'
  .then (resp) =>
    @subtitles = resp.data.data

  @
