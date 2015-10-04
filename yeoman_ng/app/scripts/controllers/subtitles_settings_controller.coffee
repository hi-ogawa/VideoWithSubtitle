@app.controller "SubtitlesSettingsController", (Globals, SpringfieldWrapper) ->
  vm = @

  vm.Globals            = Globals
  vm.SpringfieldWrapper = SpringfieldWrapper


  do ->
    vm.syncEpisode = true

  return
