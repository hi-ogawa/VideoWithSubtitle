@app.controller "SavedDataController", ($state, Globals, TvonlineWrapper, SpringfieldWrapper, Item) ->
  vm = @

  vm.$state             = $state
  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper
  vm.Globals            = Globals
  vm.Item               = Item


  vm.removeItem = (item) =>
    # TODO: possibly confirmation, but seems not necessary
    vm.Item.items.$remove(item)


  vm.restoreItem = (item) =>
    vm.Item.restoreWrappers(item)

  do ->

  return
