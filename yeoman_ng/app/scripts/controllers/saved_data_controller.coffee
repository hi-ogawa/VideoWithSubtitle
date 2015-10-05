@app.controller "SavedDataController", ($state, Globals, TvonlineWrapper, SpringfieldWrapper, Item, SearchDialog) ->
  vm = @

  vm.$state             = $state
  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper
  vm.Globals            = Globals
  vm.Item               = Item


  vm.removeItem = (item) =>
    vm.Item.items.$remove(item)


  vm.restoreItem = (item) =>
    vm.Item.restoreWrappers(item)

  do ->
    vm.Item.items.$loaded()
    .then ->
      if vm.Item.items.length is 0
        SearchDialog.showDialog()

  return
