videosubApp = angular.module 'videosubApp', ['yqlService', 'parseService']

videosubApp.controller 'videosubCtrl', ['$scope', '$sce', 'getHTMLwithYQL', 'parsers', ($scope, $sce, getHTMLwithYQL, parsers) ->

  $scope.titleQuery = 'modern'

  $scope.trustSrc = (src) ->
    $sce.trustAsResourceUrl src


  ## yql from service with promise
  url = 'http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=modern'
  getHTMLwithYQL(url).then (htmlStr) ->
    items = parsers.getTitlesFromSpringfield htmlStr
    $scope.springfieldTitleSuggestions = items
    $scope.springfieldTitle = items[0].val

  $scope.searchTitles = ->
    getTitlesFromSpringfield $scope.titleQuery, (items) ->
      $scope.springfieldTitleSuggestions = items
      $scope.springfieldTitle = items[0].val
      $scope.$apply()

    getTitlesFromTVOnline $scope.titleQuery, (items) ->
      $scope.tvonlineTitleSuggestions = items
      $scope.tvonlineTitle = items[0].val
      $scope.$apply()

  $scope.searchEpisodes = ->
    getEpisodesFromSpringfield $scope.springfieldTitle, (items) ->
      $scope.springfieldEpisodes = items
      $scope.springfieldEpisode  = items[0].val
      $scope.$apply()

    getEpisodesFromTVOnline $scope.tvonlineTitle, (items) ->
      $scope.tvonlineEpisodes = items
      $scope.tvonlineEpisode  = items[0].val
      $scope.$apply()


  $scope.showVideo = ->
    getEmbedVideos $scope.tvonlineEpisode, (items) ->
      $scope.embedVideoUrls = items
      $scope.embedVideoUrl  = items[0].val
      $scope.$apply()

  $scope.showSubtitle = ->
    getSubtitle $scope.springfieldEpisode, (text) ->
      $scope.subtitle = text
      $scope.$apply()

]
