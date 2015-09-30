@app.controller 'RootController', ($state, Globals, TvonlineWrapper, SpringfieldWrapper) ->
  vm = @

  vm.$state             = $state
  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper
  vm.Globals            = Globals

  do ->
    vm.Globals.initDropdown()

  return
