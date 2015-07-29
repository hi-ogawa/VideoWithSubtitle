videosubApp = angular.module 'videosubApp', [
    'ngAnimate', 'ngSanitize', 'ngStorage', 'yqlService', 'parseService'
]

videosubApp.controller 'videosubCtrl', [
   '$scope', '$sce', '$localStorage', 'getHTMLwithYQL', 'parsers'
  (($scope,   $sce,   $localStorage,   getHTMLwithYQL,   parsers) ->

    # initial values
    $scope.settingOn = true
    $scope.historyOn = false
    $scope.x = 1
    $scope.y = 0

    # initial setup for ngStorage
    $scope.$storage = $localStorage

    # properties (models in $scope) to save and load via local storage
    storageProps = [
        'titleQuery'
        'tvonlineTitle'
        'tvonlineEpisode'
        'tvonlineEpisodes'
        'videoProvider'
        'videoProviders'
        'springfieldTitle'
        'springfieldEpisode'
        'springfieldEpisodes'
    ]


    # init history only first time
    if !$scope.$storage.history?
      $scope.$storage.history = []         
  

    # data storing functions
    $scope.putNewData = ->
      currentData = _.pick($scope, storageProps)  # pick up only relavant models
      $scope.$storage.history.push currentData
      $scope.$storage.now = currentData           # track current state

    $scope.loadData = (data) ->
      $scope.$storage.now = data                  # track current state
      storageProps.forEach (p) ->
        $scope[p] = data[p]

    $scope.deleteData = (data) ->
      $scope.$storage.history.splice($scope.$storage.history.indexOf(data), 1)


    # load the recent data
    if $scope.$storage.now?
      $scope.loadData($scope.$storage.now) 

   
    # template urls for various search
    url0 = (query) ->
      "http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=#{query}"
    url1 = (query) ->
      "http://tvonline.tw/search.php?key=#{query}"
    url2 = (path) ->
      "http://www.springfieldspringfield.co.uk#{path}"
    url3 = (path) ->
      "http://tvonline.tw/#{path}"
    url4 = (path) ->
      "http://www.springfieldspringfield.co.uk/#{path}"
   
    # show searched tvshow titles
    $scope.searchTitles = ->

      # from springfield   
      $scope.loading0 = true
      getHTMLwithYQL(url0(encodeURIComponent($scope.titleQuery))).then (html) ->
        $scope.loading0 = false
        items = parsers.getTitlesFromSpringfield html
        $scope.springfieldTitleSuggestions = items
        $scope.springfieldTitle  = items[0]

      # from tvonline
      $scope.loading1 = true
      getHTMLwithYQL(url1(encodeURIComponent($scope.titleQuery))).then (html) ->
        $scope.loading1 = false
        items = parsers.getTitlesFromTVOnline html
        $scope.tvonlineTitleSuggestions = items
        $scope.tvonlineTitle = items[0]
   
    # show available episodes of the title from springfield
    $scope.showSpringfielEpisodes = ->
      $scope.loading2 = true
      getHTMLwithYQL(url2($scope.springfieldTitle.val)).then (html) ->
        $scope.loading2 = false
        items = parsers.getEpisodesFromSpringfield html
        $scope.springfieldEpisodes = items
        $scope.springfieldEpisode = items[0]

    # show subtitle of certain episode on Springfield
    $scope.showSubtitle = ->
      $scope.subtitleAppearance = true
      $scope.loading5 = true
      getHTMLwithYQL(url4($scope.springfieldEpisode.val)).then (html) ->
        $scope.loading5 = false
        $scope.subtitle = parsers.getSubtitle html


    # show available episodes on TVOnline
    $scope.showTVOnlineEpisodes = ->
      $scope.loading3 = true
      getHTMLwithYQL(url3($scope.tvonlineTitle.val)).then (html) ->
        $scope.loading3 = false
        items = parsers.getEpisodesFromTVOnline html
        $scope.tvonlineEpisodes = items
        $scope.tvonlineEpisode  = items[0]

   
    # show available videos of certain episode on TVOnline
    $scope.showTVOnlineVideoProviders = ->
      $scope.loading4 = true
      getHTMLwithYQL(url3($scope.tvonlineEpisode.val)).then (html) ->
        $scope.loading4 = false
        comp = (i, j) ->
          if i.name is 'nowvideo' or i.name is 'movshare' then -1 else 1
        items = parsers.getEmbedVideos(html).sort comp
        $scope.videoProviders = items
        $scope.videoProvider  = items[0]

    # put the video url into iframe
    $scope.showVideo = ->
      $scope.embedVideoUrl = $scope.videoProvider.val   
   
    # to put untrasted resource into iframe
    $scope.trustSrc = (src) ->
      $sce.trustAsResourceUrl src
   
    # change buttons color
    $scope.buttonColor = (x, y, x_, y_) ->
      if x is x_ and y is y_ then 'btn-warning' else 'btn-default'
   
    # change the place for subtitle based on button press
    $scope.position = (x, y) ->
      "subtitle-position-#{x.toString()}#{y.toString()}"

    # show previous/next episode
    $scope.jumpEpisode = (i) ->
      currentIndex0 = $scope.tvonlineEpisodes.map((e) -> e.val)
                            .indexOf($scope.tvonlineEpisode.val)
      dest0 = $scope.tvonlineEpisodes[currentIndex0 + i]
      if dest0?
        $scope.tvonlineEpisode = dest0
        $scope.showTVOnlineVideoProviders()

      currentIndex1 = $scope.springfieldEpisodes.map((e) -> e.val)
                            .indexOf($scope.springfieldEpisode.val)
      dest1 = $scope.springfieldEpisodes[currentIndex1 + i]
      if dest1?
        $scope.springfieldEpisode = dest1

    # parse episode number from episode name to present it in history row
    $scope.extractEpisodeNumber = (s) ->
      s.match(/^(.*)\ \-/)[1]

)]
