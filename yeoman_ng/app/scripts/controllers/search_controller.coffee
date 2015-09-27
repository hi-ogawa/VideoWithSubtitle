@app.controller 'SearchController', (TvonlineWrapper, SpringfieldWrapper, TvonlineFixtures, SpringfieldFixtures) ->
  vm = @

  # model declaration for better readability
  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper

  vm.search = (query) ->
    vm.titlesScrollTop()
    vm.TvonlineWrapper.search query
    vm.SpringfieldWrapper.search query

  vm.titlesScrollTop = ->
    $("#tvonline-titles .mine-scrollable").scrollTop 0
    $("#springfield-titles .mine-scrollable").scrollTop 0

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
