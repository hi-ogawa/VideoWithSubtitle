@app.service 'SearchDialog', (ngDialog) ->

  @showDialog = ->
    ngDialog.open
      template:     'views/search.html'
      controller:   'SearchController'
      controllerAs: 'vm'
      className:    'ngdialog-theme-default search-dialog'

  @
