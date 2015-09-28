@app.controller 'RootController', ($state, TvonlineWrapper, SpringfieldWrapper) ->
  vm = @

  vm.$state             = $state
  vm.TvonlineWrapper    = TvonlineWrapper
  vm.SpringfieldWrapper = SpringfieldWrapper

  return
