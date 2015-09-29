@app.controller 'SearchController', (TvonlineWrapper, SpringfieldWrapper, $state, $scope, TvonlineFixtures, SpringfieldFixtures) ->
  vm = @


  ## in-view functions ##

  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper

  vm.syncTitle   = true
  vm.syncEpisode = true

  vm.search = (query) ->
    $("#tvonline-titles .mine-scrollable").scrollTop 0
    $("#springfield-titles .mine-scrollable").scrollTop 0
    vm.TvonlineWrapper.search query
    vm.SpringfieldWrapper.search query

  vm.scrollToActiveEntry = ->
    $(".mine-scrollable").each ->
      unless _.isEmpty active = $(this).find(".active")
        $(this).animate
          scrollTop: active.offset().top - $(this).children().first().offset().top - 10
        , "slow"
    return

  # syncing functions
  vm.syncTitleTV2SP = (t) ->
    return unless vm.syncTitle
    fuse = new Fuse vm.SpringfieldWrapper.titles, {
                      keys: ["name"]
                      getFn: (t) -> removeYear(t.name)
                    }
    vm.SpringfieldWrapper.getSeasons(fuse.search(removeYear(t.name))[0])

  vm.syncTitleSP2TV = (t) ->
    return unless vm.syncTitle
    fuse = new Fuse vm.TvonlineWrapper.titles, {
                      keys: ["name"]
                      getFn: (t) -> removeYear(t.name)
                    }
    vm.TvonlineWrapper.getSeasons(fuse.search(removeYear(t.name))[0])

  vm.syncSeasonTV2SP = (s) ->
    return unless vm.syncEpisode
    vm.SpringfieldWrapper.season =
      _.find vm.SpringfieldWrapper.seasons, (s_) -> s.seasonNumber is s_.seasonNumber

  vm.syncSeasonSP2TV = (s) ->
    return unless vm.syncEpisode
    vm.TvonlineWrapper.season =
      _.find vm.TvonlineWrapper.seasons, (s_) -> s.seasonNumber is s_.seasonNumber

  vm.syncEpisodeTV2SP = (e) ->
    return unless vm.syncEpisode
    vm.SpringfieldWrapper.episode =
      _.find vm.SpringfieldWrapper.season.episodes, (e_) -> e.episodeNumber is e_.episodeNumber

  vm.syncEpisodeSP2TV = (e) ->
    return unless vm.syncEpisode
    vm.TvonlineWrapper.getVideos _.find vm.TvonlineWrapper.season.episodes, (e_) -> e.episodeNumber is e_.episodeNumber


  ## only-in-controller functions ##

  setFixtures = ->
    vm.query               = "modern"
    vm.TvonlineFixtures    = TvonlineFixtures
    vm.SpringfieldFixtures = SpringfieldFixtures

  initDropdown = ->
    $('.ui.dropdown').dropdown
       on: 'hover'

  removeYear = (name) -> name.replace /\(.*\)/, ""


  do ->
    # setFixtures()
    initDropdown()
    # vm.scrollToActiveEntry()

  return
