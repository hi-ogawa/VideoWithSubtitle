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
        templateUrl: "views/main.html"
        controller:  "MainController as vm"

  .state "watch",
    parent: "root"
    url: "/watch"
    views:
      mainView:
        templateUrl: "views/main.html"
        controller:  "MainController as vm"
