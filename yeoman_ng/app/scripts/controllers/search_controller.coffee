@app.controller 'SearchController', (TvonlineWrapper, SpringfieldWrapper, $state, $scope, TvonlineFixtures, SpringfieldFixtures) ->
  vm = @


  # in-view functions

  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper

  vm.syncTitle   = true
  vm.syncEpisode = true

  vm.search = (query) ->
    vm.titlesScrollTop()
    vm.TvonlineWrapper.search query
    vm.SpringfieldWrapper.search query

  vm.titlesScrollTop = ->
    $("#tvonline-titles .mine-scrollable").scrollTop 0
    $("#springfield-titles .mine-scrollable").scrollTop 0


  # only-in-controller functions

  setFixtures = ->
    vm.query               = "modern"
    vm.TvonlineFixtures    = TvonlineFixtures
    vm.SpringfieldFixtures = SpringfieldFixtures

  initDropdown = ->
    $('.ui.dropdown').dropdown
       on: 'hover'

  watchForSyncing = ->
    removeYear = (name) -> name.replace /\(.*\)/, ""

    $scope.$watch (-> vm.TvonlineWrapper.title), (t, oldT) ->
      return if t is oldT
      if t and vm.syncTitle
        fuse = new Fuse vm.SpringfieldWrapper.titles, {
                          keys: ["name"]
                          getFn: (t) -> removeYear(t.name)
                        }
        vm.SpringfieldWrapper.getSeasons(fuse.search(removeYear(t.name))[0])

    $scope.$watch (-> vm.SpringfieldWrapper.title), (t, oldT) ->
      return if t is oldT
      if t and vm.syncTitle
        fuse = new Fuse vm.TvonlineWrapper.titles, {
                          keys: ["name"]
                          getFn: (t) -> removeYear(t.name)
                        }
        vm.TvonlineWrapper.getSeasons(fuse.search(removeYear(t.name))[0])

    $scope.$watch (-> vm.TvonlineWrapper.season), (tvS, oldTvS) ->
      return if tvS is oldTvS
      if tvS and vm.syncEpisode
        vm.SpringfieldWrapper.season =
          _.find vm.SpringfieldWrapper.seasons, (spS) -> spS.seasonNumber is tvS.seasonNumber

    $scope.$watch (-> vm.SpringfieldWrapper.season), (spS, oldSpS) ->
      return if spS is oldSpS
      if spS and vm.syncEpisode
        vm.TvonlineWrapper.season =
          _.find vm.TvonlineWrapper.seasons, (tvS) -> spS.seasonNumber is tvS.seasonNumber

    $scope.$watch (-> vm.TvonlineWrapper.episode), (tvE, oldTvE) ->
      return if tvE is oldTvE
      if tvE and vm.syncEpisode
        vm.SpringfieldWrapper.episode =
          _.find vm.SpringfieldWrapper.season.episodes, (spE) -> spE.episodeNumber is tvE.episodeNumber

    $scope.$watch (-> vm.SpringfieldWrapper.episode), (spE, oldSpE) ->
      return if spE is oldSpE
      if spE and vm.syncEpisode
        vm.TvonlineWrapper.getVideos _.find vm.TvonlineWrapper.season.episodes, (tvE) -> spE.episodeNumber is tvE.episodeNumber


  do ->
    # setFixtures()
    initDropdown()
    watchForSyncing()

  return
