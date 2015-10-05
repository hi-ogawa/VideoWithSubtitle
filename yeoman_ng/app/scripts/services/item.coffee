@app.service "Item", (TvonlineWrapper, SpringfieldWrapper, Tvonline, Springfield, $firebaseArray, $state, SearchDialog, promiseTracker) ->

  @items = $firebaseArray new Firebase "https://substreaming.firebaseio.com/items"

  @initialItemsTracker = promiseTracker()
  @initialItemsTracker.addPromise @items.$loaded()


  @saveWrappers = =>
    @items.$add
      tvTitle:   _.pick TvonlineWrapper.title,      ['name', 'url']
      tvSeason:  _.pick TvonlineWrapper.season,     ['seasonNumber']
      tvEpisode: _.pick TvonlineWrapper.episode,    ['name', 'url', 'episodeNumber']
      spTitle:   _.pick SpringfieldWrapper.title,   ['name', 'url']
      spSeason:  _.pick SpringfieldWrapper.season,  ['seasonNumber']
      spEpisode: _.pick SpringfieldWrapper.episode, ['name', 'url', 'episodeNumber']


  @restoreWrappers = (item) =>

    # TODO: - code is ugly
    #       - stop using ugly nested promises

    SearchDialog.showDialog()

    TvonlineWrapper.titles = [item.tvTitle]
    TvonlineWrapper.setTitleInitSeasons new Tvonline.Title item.tvTitle.name, item.tvTitle.url
    .then ->
      TvonlineWrapper.season =             _.find TvonlineWrapper.title.seasons,   {seasonNumber: item.tvSeason.seasonNumber}
      TvonlineWrapper.setEpisodeInitVideos _.find TvonlineWrapper.season.episodes, {episodeNumber: item.tvEpisode.episodeNumber}

    SpringfieldWrapper.titles = [item.spTitle]
    SpringfieldWrapper.setTitleInitSeasons new Springfield.Title item.spTitle.name, item.spTitle.url
    .then ->
      SpringfieldWrapper.season =                _.find SpringfieldWrapper.title.seasons,   {seasonNumber: item.spSeason.seasonNumber}
      SpringfieldWrapper.setEpisodeInitSubtitles _.find SpringfieldWrapper.season.episodes, {episodeNumber: item.spEpisode.episodeNumber}

  @
