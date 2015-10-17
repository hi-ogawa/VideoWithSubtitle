@app.directive "speechApiHighlighter", (SpeechApi) ->
  restrict: "A"
  controller: ($scope, $element) ->

    highlightWord = (word) -> $element.highlightRegex new RegExp word, "ig"
    deHighlightWord =      -> $element.highlightRegex()

    $scope.$watch (-> SpeechApi.recentWords), (words) ->
      deHighlightWord()
      _.each words, highlightWord

    return
