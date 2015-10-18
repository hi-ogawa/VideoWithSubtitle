@app.directive "speechApiHighlighter", (SpeechApi) ->
  restrict: "A"
  controller: ($scope, $element) ->

    highlightWord = (word) ->
      try
        re = new RegExp word, "ig"
      catch err
        console.log err
      $element.highlightRegex re if re

    deHighlightWord = -> $element.highlightRegex()

    $scope.$watch (-> SpeechApi.recentWords), (words) ->
      deHighlightWord()
      _.each words, highlightWord

    return
