@app.controller 'SearchController', ->
  vm = @

  initSemantic = ->
    $('.ui.dropdown').dropdown('show')

  do ->
    initSemantic()

  return
