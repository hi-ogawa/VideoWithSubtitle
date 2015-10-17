@app.service "SpeechApi", ($window, $timeout, promiseTracker, $q) ->

  # TODO: handle error for unsuppoted browsers
  console.log "speech recognition is not suppoted on your browser" unless $window.webkitSpeechRecognition?

  _recognition                = new $window.webkitSpeechRecognition
  _recognition.continuous     = true
  _recognition.interimResults = true
  _recognition.lang           = "en-US" # TODO: should be selectable https://github.com/GoogleChrome/webplatform-samples/blob/master/webspeechdemo/webspeechdemo.html#L137-L199
  _recognition.onerror  = (ev) => console.log "_recognition.onerror"; console.log ev; @off()
  _recognition.onresult = (ev) =>

    console.log ev.results
    console.log _.map ev.results, (result) -> result.isFinal
    $timeout =>
      @results = ev.results
      @recentWords = _.takeRight _.last(ev.results)[0].transcript.split(" "), 5

  @state           = false
  @results         = []
  @recentWords     = []
  @startingTracker = promiseTracker()
  @endingTracker   = promiseTracker()

  @on = -> 
    _recognition.start()
    p = $q (resolve, reject) => _recognition.onstart = (ev) => @state = true; resolve ev 
    @startingTracker.addPromise p
    p

  @off = ->
    _recognition.stop()
    p = $q (resolve, reject) => _recognition.onend = (ev) => @state = false; resolve ev 
    @endingTracker.addPromise p
    p

  @toggle = -> if @state then @off() else @on()

  @restart = -> @off().then => @on()

  @
