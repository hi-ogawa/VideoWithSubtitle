@app.directive 'selectableList', ($filter) ->
  restrict: 'E'
  templateUrl: 'views/directives/selectable_list.html'
  scope:
    list:         "="
    listFilter:   "=?"
    elemDisplay:  "=?"
    selectedElem: "="
  controllerAs: "vm"
  bindToController: true
  controller: ->
    vm = @
    vm.listFilter  ||= (x) -> x
    vm.elemDisplay ||= (x) -> x.name
    return
