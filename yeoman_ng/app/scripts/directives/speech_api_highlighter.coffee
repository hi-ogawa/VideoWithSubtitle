@app.directive "speechApiHighlighter", (SpeechApi) ->
  restrict: "A"
  controller: ($scope, $element, $interval) ->

    # NOTE: if text is too big, highlighting will be very slow.
    spansToHighlight = ->
      $("#subtitles").children("span").filter -> isVisible $(this)

    isVisible = (dom) ->
      rangeTop    = $("#subtitles-scroll-wrap").offset().top
      rangeBottom = rangeTop + $("#subtitles-scroll-wrap").height()
      (rangeTop - 50) < dom.offset().top < (rangeBottom + 50)

    highlightWord = (word) ->
      try
        re = new RegExp word, "ig"
      catch err
        console.log err
      spansToHighlight().highlightRegex re if re

    deHighlightWord = -> $element.highlightRegex()

    # TODO: need more refined rating
    #       - not only consecutive words
    #       - put additional weight on uncommon words
    #       - take closest span from current scroolTop
    #       - long word should have bigger weight
    spanMatchedTo = (words) ->
      _($("#subtitles").children("span"))
        .map    (span) ->
          dom:  $(span)
          rate: lengthOfLongestConsecutiveMatch($(span).text(), words)
        .filter (obj)  -> obj.rate >= 4
        .sortBy (obj)  -> - obj.rate
        .first()

    lengthOfLongestConsecutiveMatch = (text, words) ->
      result =
        _(text.split(" "))
          .map (word) -> _.contains words, word
          .reduce (memo, b) ->
                    currentScore: (c = if b then memo.currentScore + 1 else 0)
                    biggestScore: Math.max(c, memo.biggestScore)
                 , {currentScore: 0, biggestScore: 0}
      result.biggestScore

    scrollToSpan = (dom) ->
      unless isVisible dom
        $("#subtitles-scroll-wrap").animate
          scrollTop: dom.offset().top - $("#subtitles span").first().offset().top

    $interval ->
      if SpeechApi.state
        deHighlightWord()
        _.each SpeechApi.recentWords, highlightWord
        scrollToSpan result.dom if result = spanMatchedTo(SpeechApi.recentWords)
    , 500

    return
