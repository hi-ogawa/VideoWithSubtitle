@app.controller "SavedDataController", ($state, Globals, TvonlineWrapper, SpringfieldWrapper) ->
  vm = @

  vm.$state             = $state
  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper
  vm.Globals            = Globals

  do ->

  return
