@app.service "SpeechApi", ($window, $timeout, promiseTracker, $q, $rootScope, $interval) ->

  # TODO: handle error for unsuppoted browsers
  console.log "speech recognition is not suppoted on your browser" unless $window.webkitSpeechRecognition?

  _recognition                = new $window.webkitSpeechRecognition
  _recognition.continuous     = true
  _recognition.interimResults = true
  _recognition.lang           = "en-US" # TODO: should be selectable https://github.com/GoogleChrome/webplatform-samples/blob/master/webspeechdemo/webspeechdemo.html#L137-L199
  _recognition.onerror  = (ev) =>
    console.log "_recognition.onerror"
    console.log ev
    @off()

  _recognition.onresult = (ev) =>
    return unless @state
    $timeout =>
      @results = ev.results
      @recentWords = _(ev.results).map (result) -> result[0].transcript.split(" ")
                                  .flatten()
                                  .filter (word) -> word.length > 1
                                  .unique()
                                  .takeRight 15
                                  .value()

  @state           = false
  @results         = []
  @recentWords     = []
  @startingTracker = promiseTracker()
  @endingTracker   = promiseTracker()

  @on = -> 
    _recognition.start()
    p = $q (resolve, reject) => _recognition.onstart = (ev) => $timeout (=> @state = true; resolve ev)
    @startingTracker.addPromise p
    p

  @off = ->
    _recognition.stop()
    @state = false
    p = $q (resolve, reject) => _recognition.onend = (ev) => resolve ev; @recentWords = []
    @endingTracker.addPromise p
    p

  @toggle = -> if @state then @off() else @on()

  @restart = -> @off().then => @on()

  _timeouts = []
  $rootScope.$watch (=> @results), (_results) =>
    p = $timeout =>
      if @state and @results is _results
        _.each _timeouts, $timeout.cancel
        _timeouts = []
        @restart()
    , 2000
    _timeouts.push p

  @
