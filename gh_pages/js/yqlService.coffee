yqlService = angular.module 'yqlService', []

# this also depends on ajax in jQuery
yqlService.factory 'getHTMLwithYQL', ['$q', ($q) ->

  getHTMLwithYQL = (url) ->
  
    deferred = $q.defer()
    yql = "http://query.yahooapis.com/v1/public/yql?q=" +
          encodeURIComponent("select * from html where url='#{url}'") +
          "&format=xml&callback=?" 
    $.ajax
      dataType: 'json'
      url: yql
      success: (data) ->
        deferred.resolve $.parseHTML(data.results[0])

    deferred.promise

  getHTMLwithYQL
]
