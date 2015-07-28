videosubApp = angular.module 'videosubApp', [
    'ngAnimate', 'ngSanitize', 'yqlService', 'parseService'
]

videosubApp.controller 'videosubCtrl', ['$scope', '$sce', 'getHTMLwithYQL', 'parsers', ($scope, $sce, getHTMLwithYQL, parsers) ->

  # initial values
  $scope.on = true
  $scope.titleQuery = ''
  $scope.x = 1
  $scope.y = 0

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

    getHTMLwithYQL(url0($scope.titleQuery)).then (html) ->
      items = parsers.getTitlesFromSpringfield html
      $scope.springfieldTitleSuggestions = items
      $scope.springfieldTitle = items[0].val

    getHTMLwithYQL(url1($scope.titleQuery)).then (html) ->
      items = parsers.getTitlesFromTVOnline html
      $scope.tvonlineTitleSuggestions = items
      $scope.tvonlineTitle = items[0].val


  # show available episodes on Springfield
  $scope.$watch 'springfieldTitle', (newValue, oldValue) ->

    getHTMLwithYQL(url2(newValue)).then (html) ->
      items = parsers.getEpisodesFromSpringfield html
      $scope.springfieldEpisodes = items
      $scope.springfieldEpisode  = items[0].val

  # show available episodes on TVOnline
  $scope.$watch 'tvonlineTitle', (newValue, oldValue) ->

    getHTMLwithYQL(url3(newValue)).then (html) ->
      items = parsers.getEpisodesFromTVOnline html
      $scope.tvonlineEpisodes = items
      $scope.tvonlineEpisode  = items[0].val

  # show available videos of certain episode on TVOnline
  $scope.$watch 'tvonlineEpisode', (newValue, oldValue) ->

    getHTMLwithYQL(url3(newValue)).then (html) ->
      comp = (i, j) ->
        if i.name is 'nowvideo' or i.name is 'movshare' then -1 else 1
      items = parsers.getEmbedVideos(html).sort comp
      $scope.embedVideoUrls = items
      $scope.embedVideoUrl  = items[0].val

  # show subtitle of certain episode on Springfield
  $scope.$watch 'springfieldEpisode', (newValue, oldValue) ->

    getHTMLwithYQL(url4(newValue)).then (html) ->
      $scope.subtitle = parsers.getSubtitle html


  # to put untrasted resource into iframe
  $scope.trustSrc = (src) ->
    $sce.trustAsResourceUrl src

  $scope.position = (x, y) ->
    "subtitle-position-#{x.toString()}#{y.toString()}"
]
