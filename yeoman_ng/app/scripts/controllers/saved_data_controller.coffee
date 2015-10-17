@app.controller "SavedDataController", (Item, SearchDialog, Auth, promiseTracker, SpeechApi) ->
  vm = @

  vm.Item      = Item
  vm.Auth      = Auth
  vm.SpeechApi = SpeechApi

  do ->
    p = vm.Auth.setItems().then ->
      if vm.Auth.userItems.length is 0
        SearchDialog.showDialog()
    # (vm.itemsTracker = promiseTracker()).addPromise p

  return
