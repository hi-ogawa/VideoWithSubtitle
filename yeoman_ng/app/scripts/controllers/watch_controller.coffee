@app.controller 'WatchController', (TvonlineWrapper, SpringfieldWrapper, $stateParams, $sce, $http) ->
  vm = @

  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper
  vm.$sce               = $sce
  vm.subtitlesMode      = false

  setFixtures = ->
    vm.TvonlineWrapper.video = {name: "nowvideo", url: "http://embed.nowvideo.sx/embed.php?v=a42bb40c6ff8f"}
    $http.get '/fixtures/springfield_subtitles.json'
    .then (resp) =>
      vm.SpringfieldWrapper.subtitles = $sce.trustAsHtml resp.data.data

  do ->
    # setFixtures()
    switch $stateParams.way
      when "withSubs"
        vm.subtitlesMode = true
        vm.SpringfieldWrapper.getSubtitles vm.SpringfieldWrapper.episode
      when "withoutSubs"
        vm.subtitlesMode = false

  return
