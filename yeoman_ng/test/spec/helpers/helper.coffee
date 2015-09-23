beforeEach module 'mainAppApp'

beforeEach inject ($httpBackend, $compile, $rootScope, $controller, $location, $injector, $timeout, $state, $interval) ->
  @http       = $httpBackend
  @scope      = $rootScope.$new()
  @state      = $state
  @timeout    = $timeout
  @compile    = $compile
  @injector   = $injector
  @location   = $location
  @controller = $controller
  @interval   = $interval
  @model = (name) =>
    @injector.get(name)
  @eventLoop =
    flush: =>
      @scope.$digest()

  @waitForQ = (pred, t) =>

    new Promise (resolve, reject) =>

      looper = timer = null

      clearThoseGuys = =>
        clearInterval looper
        clearTimeout  timer

      looper = setInterval =>
        @scope.$digest()
        if pred()
          clearThoseGuys()
          resolve()
      , 100

      timer = setTimeout =>
        clearThoseGuys()
        reject()
      , t
