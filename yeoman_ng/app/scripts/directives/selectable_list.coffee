@app.directive 'selectableList', ->
  restrict: 'E'
  templateUrl: 'views/directives/selectable_list.html'
  scope:
    list:          "="
    selectedValue: "="
  controller: -> return
  controllerAs: "vm"
  bindToController: true
