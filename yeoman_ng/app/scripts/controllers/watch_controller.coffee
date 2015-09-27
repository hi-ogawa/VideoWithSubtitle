@app.controller 'WatchController', (TvonlineWrapper, SpringfieldWrapper, $http, $sce) ->
  vm = @
  vm.TvonlineWrapper = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper

  vm.trustSrc = (url) ->
    $sce.trustAsResourceUrl url

  setFixtures = ->
    vm.TvonlineWrapper.video = {name: "nowvideo", url: "http://embed.nowvideo.sx/embed.php?v=a42bb40c6ff8f"}
    $http.get '/fixtures/springfield_subtitles.json'
    .then (resp) =>
      vm.SpringfieldWrapper.subtitles = $sce.trustAsHtml resp.data.data

  do ->
    setFixtures()

  return
