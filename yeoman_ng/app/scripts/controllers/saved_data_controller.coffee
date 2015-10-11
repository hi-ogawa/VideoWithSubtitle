@app.controller "SavedDataController", (Item, SearchDialog, Auth, promiseTracker) ->
  vm = @

  vm.Item               = Item
  vm.Auth               = Auth

  do ->
    p = vm.Auth.setItems().then ->
      if vm.Auth.userItems.length is 0
        SearchDialog.showDialog()
    # (vm.itemsTracker = promiseTracker()).addPromise p

  return
