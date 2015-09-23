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


  # (simple) handle digest loop to flush $q promise
  @digestLooper = null

  @clearDigestLoop = =>
    clearInterval @digestLooper

  @makeDigestLoop = =>
    @digestLooper = setInterval =>
      @scope.$digest()
    , 100


  # (complicated)
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

  # example.
  # titles = null
  # @Springfield.search "modern"
  # .then (res) -> titles = res
  # @waitForQ (-> titles isnt null), 3000
  # .then ->
  #   console.log titles
  #   done()
  # .catch (err) ->
  #   done()
  #   throw "Springfield.search didn't return in 3 sec"


# response time would vary depending on network quality
jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000

