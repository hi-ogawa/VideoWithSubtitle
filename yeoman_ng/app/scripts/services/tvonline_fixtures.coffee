@app.service 'TvonlineFixtures', (Tvonline, $http) ->

  $http.get '/fixtures/tvonline_titles.json'
  .then (resp) =>
    @titles = _.map resp.data, (t) => new Tvonline.Title t.name, t.url


  $http.get '/fixtures/tvonline_episodes.json'
  .then (resp) =>
    @episodes = _.map resp.data, (e) => new Tvonline.Episode e.name, e.url, e.season, e.episode


  $http.get '/fixtures/tvonline_videos.json'
  .then (resp) =>
    @videos = _.map resp.data, (e) => new Tvonline.Video e.name, e.url

  @
