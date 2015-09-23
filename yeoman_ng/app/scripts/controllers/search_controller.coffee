@app.controller 'SearchController', (SpringfieldFixtures, TvonlineFixtures) ->
  vm = @

  initSemantic = ->
    $('.ui.dropdown').dropdown('show')

  vm.debug = ->
    console.log vm.value0
    console.log vm.value1

  setFixtures = ->
    vm.query               = "modern"
    vm.SpringfieldFixtures = SpringfieldFixtures
    vm.TvonlineFixtures    = TvonlineFixtures

  do ->
    initSemantic()
    setFixtures()

  return
