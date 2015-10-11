@app.directive "initialLoader", ->
  restrict: "E"
  templateUrl: "views/directives/initial_loader.html"
  bindToController: true
  controllerAs: "vm"
  controller: (Globals) ->
    vm = @
    vm.Globals = Globals
    return
