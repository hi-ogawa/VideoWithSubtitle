@app.controller 'WatchController', (TvonlineWrapper, SpringfieldWrapper, $http) ->
  vm = @
  vm.TvonlineWrapper = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper

  setFixtures = ->
    vm.TvonlineWrapper.video = {name: "nowvideo", url: "http://embed.nowvideo.sx/embed.php?v=a42bb40c6ff8f"}
    $http.get '/fixtures/springfield_subtitles.json'
    .then (resp) =>
      console.log vm.SpringfieldWrapper.subtitles = resp.data.data

  do ->
    setFixtures()

  return
