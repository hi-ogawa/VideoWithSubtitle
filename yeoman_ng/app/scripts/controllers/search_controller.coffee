@app.controller 'SearchController', (TvonlineWrapper, SpringfieldWrapper, $state, TvonlineFixtures, SpringfieldFixtures) ->
  vm = @

  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper

  vm.search = (query) ->
    vm.titlesScrollTop()
    vm.TvonlineWrapper.search query
    vm.SpringfieldWrapper.search query

  vm.titlesScrollTop = ->
    $("#tvonline-titles .mine-scrollable").scrollTop 0
    $("#springfield-titles .mine-scrollable").scrollTop 0

  vm.goToWatch = (way) ->
    $state.go 'watch', {way: way}

  setFixtures = ->
    vm.query               = "modern"
    vm.TvonlineFixtures    = TvonlineFixtures
    vm.SpringfieldFixtures = SpringfieldFixtures

  initDropdown = ->
    $('.ui.dropdown').dropdown
       on: 'hover'

  do ->
    # setFixtures()
    initDropdown()

  return
