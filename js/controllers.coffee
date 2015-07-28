videosubApp = angular.module 'videosubApp', [
    'ngAnimate', 'ngSanitize', 'yqlService', 'parseService'
]

videosubApp.controller 'videosubCtrl', ['$scope', '$sce', 'getHTMLwithYQL', 'parsers', ($scope, $sce, getHTMLwithYQL, parsers) ->

  # initial values
  $scope.on = true
  $scope.titleQuery = ''
  $scope.x = 1
  $scope.y = 0
  $scope.subtitle = ''

  # template urls
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
  $scope.searchTitles = () ->

    $scope.loading0 = true
    getHTMLwithYQL(url0($scope.titleQuery)).then (html) ->
      $scope.loading0 = false
      items = parsers.getTitlesFromSpringfield html
      $scope.springfieldTitleSuggestions = items
      $scope.springfieldTitle = items[0].val

    $scope.loading1 = true
    getHTMLwithYQL(url1($scope.titleQuery)).then (html) ->
      $scope.loading1 = false
      items = parsers.getTitlesFromTVOnline html
      $scope.tvonlineTitleSuggestions = items
      $scope.tvonlineTitle = items[0].val


  # show available episodes on Springfield
  $scope.$watch 'springfieldTitle', (newValue, oldValue) ->

    if newValue
      $scope.loading2 = true
      getHTMLwithYQL(url2(newValue)).then (html) ->
        $scope.loading2 = false
        items = parsers.getEpisodesFromSpringfield html
        $scope.springfieldEpisodes = items
        $scope.springfieldEpisode  = items[0].val

  # show available episodes on TVOnline
  $scope.$watch 'tvonlineTitle', (newValue, oldValue) ->

    if newValue
      $scope.loading3 = true
      getHTMLwithYQL(url3(newValue)).then (html) ->
        $scope.loading3 = false
        items = parsers.getEpisodesFromTVOnline html
        $scope.tvonlineEpisodes = items
        $scope.tvonlineEpisode  = items[0].val

  # show available videos of certain episode on TVOnline
  $scope.$watch 'tvonlineEpisode', (newValue, oldValue) ->

    if newValue
      $scope.loading4 = true
      getHTMLwithYQL(url3(newValue)).then (html) ->
        $scope.loading4 = false
        comp = (i, j) ->
          if i.name is 'nowvideo' or i.name is 'movshare' then -1 else 1
        items = parsers.getEmbedVideos(html).sort comp
        $scope.embedVideoUrls = items
        $scope.embedVideoUrl  = items[0].val

  # show subtitle of certain episode on Springfield
  $scope.$watch 'springfieldEpisode', (newValue, oldValue) ->

    if newValue
      $scope.loading5 = true
      getHTMLwithYQL(url4(newValue)).then (html) ->
        $scope.loading5 = false
        $scope.subtitle = parsers.getSubtitle html

  # to put untrasted resource into iframe
  $scope.trustSrc = (src) ->
    $sce.trustAsResourceUrl src


  # change buttons color
  $scope.buttonColor = (x, y, x_, y_) ->
    if x is x_ and y is y_ then 'btn-warning' else 'btn-default'

  # change the place for subtitle based on button press
  $scope.position = (x, y) ->
    "subtitle-position-#{x.toString()}#{y.toString()}"
]
