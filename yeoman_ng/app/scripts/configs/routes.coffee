@app.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise "/watch"

  $stateProvider

  .state "root",
    abstract: true
    templateUrl: "views/root.html"
    controller:  "RootController as vm"

  .state "watch",
    parent: "root"
    url: "/watch"
    views:
      mainView:
        templateUrl: "views/watch.html"
        controller:  "WatchController as vm"
    resolve:
      redirectToSearch: (SearchDialog, TvonlineWrapper) ->
        unless TvonlineWrapper.video
          SearchDialog.showDialog()

  .state "savedData",
    parent: "root"
    url: "/savedData"
    views:
      mainView:
        templateUrl: "views/saved_data.html"
        controller:  "SavedDataController as vm"
