@app.service "TextRating", ->

  # TODO: need more refined rating (faster)
  #       - not only consecutive words
  #       - put additional weight on uncommon words
  #       - take closest span from current scroolTop
  #       - long word should have bigger weight

  @filterAndPartition = (ar, pred) ->
    partitions = []
    current = []
    _.each ar, (elem) ->
      if pred elem
        current.push elem
      else
        partitions.push current
        current = []
    partitions.push current
    _.reject partitions, _.isEmpty

  @weight =
    consecutive: (group) -> if group.length >= 2 then group.length else 0
    word: (w) -> w.length * 0.1

  _sum = (ar) -> _.reduce ar, ((memo, elem) -> memo + elem), 0

  @wordLengthAndConsecutiveRating = (text, words) ->
    consecutiveGroups = @filterAndPartition text.split(" "), (w) -> _.contains words, w
    scores =_.map consecutiveGroups, (groupWords) =>
                @weight.consecutive(groupWords) + _sum _.map groupWords, @weight.word
    _sum scores

  @longestConsecutiveMatch = (text, words) ->
    result =
      _(text.split(" "))
        .map (word) -> _.contains words, word
        .reduce (memo, b) ->
                  currentScore: (c = if b then memo.currentScore + 1 else 0)
                  biggestScore: Math.max(c, memo.biggestScore)
               , {currentScore: 0, biggestScore: 0}
    result.biggestScore

  @
