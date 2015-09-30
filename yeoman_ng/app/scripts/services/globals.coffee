@app.service 'Globals', ->
  {
    subtitlesMode: false
    subtitlesCssLeft: 50
    initDropdown: (selector, options) ->
      $('.ui.dropdown').dropdown
        on: 'hover'
      return
    initPopup: (selector, options) ->
      $(".mine-popup").popup()
      return
  }
