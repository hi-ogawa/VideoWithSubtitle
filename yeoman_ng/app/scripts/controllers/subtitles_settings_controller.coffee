@app.controller "SubtitlesSettingsController", (Globals, SpringfieldWrapper) ->
  vm = @

  vm.Globals            = Globals
  vm.SpringfieldWrapper = SpringfieldWrapper

  return
