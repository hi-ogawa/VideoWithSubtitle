@app.controller 'RootController', ($state) ->
  vm = @

  vm.$state = $state

  return
