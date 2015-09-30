@app.service 'Globals', ->
  {
    subtitlesMode: false
    initDropdown: (selector, options) ->
      $('.ui.dropdown').dropdown
        on: 'hover'
      return
  }
