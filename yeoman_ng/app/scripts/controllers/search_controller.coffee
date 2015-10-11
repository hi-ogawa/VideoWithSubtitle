@app.controller 'SearchController', (Globals, TvonlineWrapper, SpringfieldWrapper, $state, $scope, $timeout, TvonlineFixtures, SpringfieldFixtures, Item, ngDialog, Auth) ->
  vm = @


  ## in-view functions ##

  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper
  vm.Globals            = Globals
  vm.ngDialog           = ngDialog
  vm.Item               = Item
  vm.Auth               = Auth

  vm.syncTitle   = true
  vm.syncEpisode = true

  vm.tvonlineTitlesSelector      = "#tvonline-titles"
  vm.tvonlineEpisodesSelector    = "#tvonline-episodes"
  vm.tvonlineVideosSelector      = "#tvonline-videos"
  vm.springfieldTitlesSelector   = "#springfield-titles"
  vm.springfieldEpisodesSelector = "#springfield-episodes"


  vm.search = (query) ->
    $(vm.tvonlineTitlesSelector).scrollTop 0
    $(vm.springfieldTitlesSelector).scrollTop 0
    vm.TvonlineWrapper.search query
    vm.SpringfieldWrapper.search query


  vm.scrollToActiveEntry = (selector) ->
    unless _.isEmpty active = $(selector).find("a.active")
      $(selector).animate
        scrollTop: active.offset().top - $(selector).children().first().offset().top - 10
      , "slow"
    return


  vm.onClickTvonlinTitle = (tvT) ->
    vm.TvonlineWrapper.setTitleInitSeasons tvT
    if vm.syncTitle
      spT = _getSimilarTitle vm.SpringfieldWrapper.titles, tvT
      vm.SpringfieldWrapper.setTitleInitSeasons spT
      $timeout -> vm.scrollToActiveEntry(vm.springfieldTitlesSelector)


  vm.onClickSpringfieldTitle = (spT) ->
    vm.SpringfieldWrapper.setTitleInitSeasons spT
    if vm.syncTitle
      tvT = _getSimilarTitle vm.TvonlineWrapper.titles, spT
      vm.TvonlineWrapper.setTitleInitSeasons tvT
      $timeout -> vm.scrollToActiveEntry(vm.tvonlineTitlesSelector)


  vm.onClickTvonlinSeason = (s) ->
    vm.TvonlineWrapper.season = s
    if vm.syncEpisode
      vm.SpringfieldWrapper.season = _getSameSeason vm.SpringfieldWrapper.title.seasons, s


  vm.onClickSpringfieldSeason = (s) ->
    vm.SpringfieldWrapper.season = s
    if vm.syncEpisode
      vm.TvonlineWrapper.season = _getSameSeason vm.TvonlineWrapper.title.seasons, s


  vm.onClickTvonlinEpisode = (tvE) ->
    vm.TvonlineWrapper.setEpisodeInitVideos tvE
    if vm.syncEpisode
      spE = _getSameEpisode vm.SpringfieldWrapper.season.episodes, tvE
      vm.SpringfieldWrapper.setEpisodeInitSubtitles spE
      $timeout -> vm.scrollToActiveEntry(vm.springfieldEpisodesSelector)

  vm.onClickSpringfieldEpisode = (spE) ->
    vm.SpringfieldWrapper.setEpisodeInitSubtitles spE
    if vm.syncEpisode
      tvE = _getSameEpisode vm.TvonlineWrapper.season.episodes, spE
      vm.TvonlineWrapper.setEpisodeInitVideos tvE
      $timeout -> vm.scrollToActiveEntry(vm.tvonlineEpisodesSelector)


  ## only-in-controller functions ##

  # syncing functions
  _getSimilarTitle = (ts, t) ->
    fuse = new Fuse ts, {keys: ["name"], getFn: (t) -> removeYear(t.name)}
    fuse.search(removeYear(t.name))[0]


  _getSameSeason = (ss, s) ->
    # TODO: error handle not-found case
    _.find ss, (s_) -> s.seasonNumber is s_.seasonNumber


  _getSameEpisode = (es, e) ->
    # TODO: error handle not-found case
    _.find es, (e_) -> e.episodeNumber is e_.episodeNumber


  setFixtures = ->
    vm.query               = "modern"
    vm.TvonlineFixtures    = TvonlineFixtures
    vm.SpringfieldFixtures = SpringfieldFixtures

  removeYear = (name) -> name.replace /\(.*\)/, ""

  do ->
    # setFixtures()

    # NOTE: when apeearing from ngDialog, semantic-ui dropdown needs to wait a sec.
    $timeout ->
      vm.Globals.initDropdown()
    , 10

  return
