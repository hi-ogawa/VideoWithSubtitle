@app.directive "speechApiHighlighter", (SpeechApi) ->
  restrict: "A"
  controller: ($scope, $element, $interval) ->

    # NOTE: if text is too big, highlighting will be very slow.
    spansToHighlight = ->
      rangeTop    = $("#subtitles-scroll-wrap").offset().top
      rangeBottom = rangeTop + $("#subtitles-scroll-wrap").height()
      $("#subtitles").children("span")
        .filter -> (rangeTop - 50) < $(this).offset().top < (rangeBottom + 50)

    highlightWord = (word) ->
      try
        re = new RegExp word, "ig"
      catch err
        console.log err
      spansToHighlight().highlightRegex re if re

    deHighlightWord = -> $element.highlightRegex()

    $scope.$watch (-> SpeechApi.recentWords), (words) ->
      deHighlightWord()
      _.each words, highlightWord

    return
