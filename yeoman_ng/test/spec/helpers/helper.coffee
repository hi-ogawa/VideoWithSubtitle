beforeEach module 'mainAppApp'

beforeEach inject ($httpBackend, $compile, $rootScope, $controller, $location, $injector, $timeout, $state) ->
  @http = $httpBackend
  @scope = $rootScope.$new()
  @state = $state
  @timeout = $timeout
  @compile = $compile
  @injector = $injector
  @location = $location
  @controller = $controller
  @model = (name) =>
    @injector.get(name)
  @eventLoop =
    flush: =>
      @scope.$digest()

