describe "TextRating", ->

  beforeEach ->
    @TextRating = @model "TextRating"

  describe "#filterAndPartition", ->
    it "", ->
      ar = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      pred = (n) -> n % 3 isnt 0
      expect @TextRating.filterAndPartition ar, pred
      .toEqual [[1, 2], [4, 5], [7, 8], [10]]


  describe "#wordLengthAndConsecutiveRating", ->
    it "", ->
      text  = "we've decided we really wanted to have a baby so, we initially asked one of our lesbian friends to be a surrogate"
      words = ["we", "really", "wanted", "baby", "lesbian", "friends", "surrogate"]
      expect @TextRating.wordLengthAndConsecutiveRating text, words
      .toBeCloseTo 9.3

  describe "#longestConsecutiveMatch", ->
    it "", ->
      text  = "we've decided we really wanted to have a baby so, we initially asked one of our lesbian friends to be a surrogate"
      words = ["we", "really", "wanted", "baby", "of", "our", "lesbian", "friends", "surrogate"]
      expect @TextRating.longestConsecutiveMatch text, words
      .toEqual 4
