@app.service 'Yql', ['$q', ($q) ->

  @getHTML = (url) ->
    $q (resolve, reject) ->

      yqlUrl = "http://query.yahooapis.com/v1/public/yql?q=" +
                encodeURIComponent("select * from html where url='#{url}'") +
               "&format=xml&callback=?" 

      $.ajax
        dataType: 'json'
        url:       yqlUrl
        success: (resp)               -> resolve $($.parseHTML(resp.results[0]))
        error:   (xhr, status, error) -> reject xhr.responseText

  @
]
