videosubApp = angular.module 'videosubApp', []

videosubApp.controller 'videosubCtrl', ['$scope', '$http', '$sce', '$q', ($scope,   $http,   $sce,  $q) ->

  $scope.trustSrc = (src) ->
    $sce.trustAsResourceUrl src

  $scope.titleQuery = 'modern'

  ## yql with $http

  url = 'http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=modern'

  yql = "http://query.yahooapis.com/v1/public/yql?q=" +
        encodeURIComponent("select * from html where url='#{url}'") +
        "&format=xml&callback=?" 

  console.log yql

  $http.get(yql).
          success( (data, status, headers, config) ->
            console.log 'success'
            console.log status
            console.log data
            console.log headers
            console.log config
          ).
          error (data, status, headers, config) ->
            console.log 'error'
            console.log status
            console.log data


  # promise experiments
  httpPromise = $http.get('index.haml').then (result) ->
    console.log 'http is resolved, but the model is not updated'
    result.data

  $scope.httpPromisedValue = httpPromise
    
  $scope.$watch 'titleQuery', (newVal, oldVal) ->
    $scope.watchedValue = $scope.titleQuery + ': watched'

  p = $q (resolve, reject) ->
          setTimeout( () ->
            resolve "resolve"
          , 3000)
  $scope.promisedValue = p.then (suc) ->
    console.log "$q promise is resolved, but the model is not updated"
    "resolve: #{suc}"

  $scope.updateModels = ->   # this just gives me error
    $scope.$apply()
  # promise experiments



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

  # url = 'http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=modern'
  # getCrossHTML url, console.log                 # this doesn't work
  # getCrossHTML url, console.log.bind(console)   # this works
  # getCrossHTML url, (arg) -> console.log arg    # this works  

]
