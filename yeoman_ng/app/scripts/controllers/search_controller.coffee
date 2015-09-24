@app.controller 'SearchController', (SpringfieldFixtures, TvonlineFixtures) ->
  vm = @

  vm.filter0 = (titles) -> 

  vm.filter1 = (title) -> title.name

  vm.debug = ->

  setFixtures = ->
    vm.query               = "modern"
    vm.SpringfieldFixtures = SpringfieldFixtures
    vm.TvonlineFixtures    = TvonlineFixtures

  do ->
    setFixtures()

  return
