@app.controller 'WatchController', (Globals, TvonlineWrapper, SpringfieldWrapper, $sce, $stateParams, $http) ->
  vm = @

  vm.TvonlineWrapper        = TvonlineWrapper
  vm.SpringfieldWrapper     = SpringfieldWrapper
  vm.$sce                   = $sce
  vm.Globals                = Globals

  vm.domAutoScroller        = $("#auto-scroller")
  vm.domSubtitlesScrollWrap = $("#subtitles-scroll-wrap")
  vm.domSubtitles           = $("#subtitles")

  vm.moveScroller = (ev) ->
    vm.domSubtitlesScrollWrap.stop()
    # -1 < speedRate < 1
    speedRate       = ((ev.pageY - vm.domAutoScroller.offset().top) / vm.domAutoScroller.height()) * 2 - 1
    speedPxPerSec   = 200 * Math.abs(speedRate)
    moveDestination = if speedRate > 0 then vm.domSubtitles.height() - vm.domSubtitlesScrollWrap.height() else 0
    moveDistancePx  = Math.abs(moveDestination - vm.domSubtitlesScrollWrap.scrollTop())
    vm.domSubtitlesScrollWrap.animate
      scrollTop: moveDestination
      , {duration: (moveDistancePx / Math.abs(speedPxPerSec)) * 1000, easing: "linear"}
    return

  vm.stopScroller = ->
    vm.domSubtitlesScrollWrap.stop()
    return

  setFixtures = ->
    vm.TvonlineWrapper.video = {name: "nowvideo", url: "http://embed.nowvideo.sx/embed.php?v=a42bb40c6ff8f"}
    $http.get '/fixtures/springfield_subtitles.json'
    .then (resp) =>
      vm.SpringfieldWrapper.episode = {}
      vm.SpringfieldWrapper.episode.subtitles = resp.data.data

  do ->
    # setFixtures()

  return
