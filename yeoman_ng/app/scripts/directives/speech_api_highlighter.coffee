@app.directive "speechApiHighlighter", (SpeechApi, TextRating) ->
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
          rate: calculateRate($(span).text(), words)
        .filter (obj)  -> obj.rate >= 5
        .sortBy (obj)  -> - obj.rate
        .first()

    # calculateRate = (text, words) -> TextRating.longestConsecutiveMatch text, words
    calculateRate = (text, words) -> TextRating.wordLengthAndConsecutiveRating text, words

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
