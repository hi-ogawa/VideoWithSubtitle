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


# response time would vary depending on network quality
jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000

# http://stackoverflow.com/questions/23676459/karma-jasmine-pretty-printing-object-comparison
jasmine.pp = (obj) -> JSON.stringify obj, null, 2


omitTrackers = (objs) ->
  _.map objs, (obj) -> omitTracker obj

omitTracker  = (obj)  ->
  _.mapValues obj, (val) ->
    return null if val?.constructor?.name is 'PromiseTracker'
    val
