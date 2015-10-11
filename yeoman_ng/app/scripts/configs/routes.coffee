@app.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise "/watch"

  _initAuth = (Auth, Globals) ->
    p = Auth.authObj.$waitForAuth()
        .then (authData) -> if authData? then Auth.setUser(authData).then -> Auth.setItems()
    Globals.initialLoaderTracker.addPromise p
    p

  _requireAuth = (Auth) -> Auth.authObj.$requireAuth()

  $stateProvider

  .state "root",
    abstract: true
    templateUrl: "views/root.html"
    controller:  "RootController as vm"
    resolve: ___: _initAuth

  .state "watch",
    parent: "root"
    url: "/watch"
    views:
      mainView:
        templateUrl: "views/watch.html"
        controller:  "WatchController as vm"

  .state "savedData",
    parent: "root"
    url: "/savedData"
    views:
      mainView:
        templateUrl: "views/saved_data.html"
        controller:  "SavedDataController as vm"
    resolve: ___: _requireAuth


@app.run ($rootScope, $state) ->

  $rootScope.$on "$stateChangeError", (e, toState, toParams, fromState, fromParams, err) ->
    if err is "AUTH_REQUIRED"
      $state.go "watch"
