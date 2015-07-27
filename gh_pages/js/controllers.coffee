videosubApp = angular.module 'videosubApp', []

videosubApp.controller 'videosubCtrl', ['$scope', '$http' , ($scope, $http) ->

  $scope.searchTitle = ->
    getTitlesFromSpringfield $scope.titleQuery, (items) ->
      $scope.springfieldTitleSuggestions = items
      $scope.springfieldTitle = items[0].val
      $scope.$apply()

    getTitlesFromTVOnline $scope.titleQuery, (items) ->
      $scope.tvonlineTitleSuggestions = items
      $scope.tvonlineTitle = items[0].val
      $scope.$apply()
      

    # url = 'http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=modern'
    # getCrossHTML url, console.log                 # this doesn't work
    # getCrossHTML url, console.log.bind(console)   # this works
    # getCrossHTML url, (arg) -> console.log arg    # this works  
    

]
