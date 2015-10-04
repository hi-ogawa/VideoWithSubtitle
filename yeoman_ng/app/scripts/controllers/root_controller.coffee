@app.controller 'RootController', (ngDialog, SearchDialog, $state, Globals, TvonlineWrapper, SpringfieldWrapper) ->
  vm = @

  vm.$state             = $state
  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper
  vm.ngDialog           = ngDialog
  vm.SearchDialog       = SearchDialog
  vm.Globals            = Globals


  vm.currentStateIs = (state) ->
    vm.$state.current.name is state


  vm.showSubtitlesSettings = ->
    ngDialog.open
      template:     'views/subtitles_settings.html'
      controller:   'SubtitlesSettingsController'
      controllerAs: 'vm'
      className:    'ngdialog-theme-default subtitles-settings-dialog'


  vm.goNext = ->

    ## change Tvonline episode TODO: scrolling if it's on search page
    currentVideo = vm.TvonlineWrapper.video

    if nextEpisode = _.find vm.TvonlineWrapper.season.episodes, {episodeNumber: vm.TvonlineWrapper.episode.episodeNumber + 1}
      vm.TvonlineWrapper.setEpisodeInitVideos nextEpisode

    else if nextSeason = _.find vm.TvonlineWrapper.title.seasons, {seasonNumber: vm.TvonlineWrapper.season.seasonNumber + 1}
      vm.TvonlineWrapper.season = nextSeason
      vm.TvonlineWrapper.setEpisodeInitVideos nextSeason.episodes[0]

    else
      # TODO: error message for being sorry about not found
      vm.SearchDialog.showDialog()


    ## use same video provider if possible
    if currentVideo
      vm.TvonlineWrapper.episode.videosP
      .then =>
        if nextVideo = _.find vm.TvonlineWrapper.episode.videos, {name: currentVideo.name}
          vm.TvonlineWrapper.video = nextVideo
        else
          # TODO: error message for being sorry about not found
          #       or find the good provider instead
          vm.TvonlineWrapper.video = null
          vm.SearchDialog.showDialog()

    _setSpringfieldBasedOnTvonline()


  vm.goPrevious = ->

    ## change Tvonline episode TODO: scrolling if it's on search page
    currentVideo = vm.TvonlineWrapper.video

    if previousEpisode = _.find vm.TvonlineWrapper.season.episodes, {episodeNumber: vm.TvonlineWrapper.episode.episodeNumber - 1}
      vm.TvonlineWrapper.setEpisodeInitVideos previousEpisode

    else if previousSeason = _.find vm.TvonlineWrapper.title.seasons, {seasonNumber: vm.TvonlineWrapper.season.seasonNumber - 1}
      vm.TvonlineWrapper.season = previousSeason
      vm.TvonlineWrapper.setEpisodeInitVideos previousSeason.episodes[0]

    else
      # TODO: error message for being sorry about not found
      vm.SearchDialog.showDialog()


    ## use same video provider if possible
    if currentVideo
      vm.TvonlineWrapper.episode.videosP
      .then =>
        if previousVideo = _.find vm.TvonlineWrapper.episode.videos, {name: currentVideo.name}
          vm.TvonlineWrapper.video = previousVideo
        else
          # TODO: error message for being sorry about not found
          #       or find the good provider instead
          vm.TvonlineWrapper.video = null
          vm.SearchDialog.showDialog()


    _setSpringfieldBasedOnTvonline()


  # TODO: scrolling if it's on search page
  _setSpringfieldBasedOnTvonline = ->
    vm.SpringfieldWrapper.season = _.find vm.SpringfieldWrapper.title.seasons
                                        , {seasonNumber: vm.TvonlineWrapper.season.seasonNumber}
    vm.SpringfieldWrapper.setEpisodeInitSubtitles _.find vm.SpringfieldWrapper.season.episodes
                                                       , {episodeNumber: vm.TvonlineWrapper.episode.episodeNumber}


  do ->
    vm.Globals.initDropdown()
    vm.Globals.initPopup()

  return
