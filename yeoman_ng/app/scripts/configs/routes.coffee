@app.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise "/search"

  $stateProvider

  .state "root",
    abstract: true
    templateUrl: "views/root.html"
    controller:  "RootController as vm"

  .state "search",
    parent: "root"
    url: "/search"
    views:
      mainView:
        templateUrl: "views/search.html"
        controller:  "SearchController as vm"

  .state "savedData",
    parent: "root"
    url: "/savedData"
    views:
      mainView:
        templateUrl: "views/saved_data.html"
        controller:  "SavedDataController as vm"

  .state "watch",
    parent: "root"
    url: "/watch"
    views:
      mainView:
        templateUrl: "views/watch.html"
        controller:  "WatchController as vm"
    resolve:
      redirectToSearch: (TvonlineWrapper, SpringfieldWrapper, $state, $q) ->
        unless TvonlineWrapper.video
          $q.reject "video is not set"


@app.run ($rootScope, $state) ->

  $rootScope.$on "$stateChangeError", (e, toState, toParams, fromState, fromParams, err) ->
    if err is "video is not set"
      $state.go "search"
