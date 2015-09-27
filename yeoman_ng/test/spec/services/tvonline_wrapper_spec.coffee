describe "TvonlineWrapper", ->

  beforeEach ->
    @TvonlineWrapper = @model "TvonlineWrapper"
    @makeDigestLoop()

  afterEach -> @clearDigestLoop()

  describe "#search", ->

    it "only updates #titles with the results of a final query", (done) ->

      @TvonlineWrapper.search "modern family"
      @TvonlineWrapper.search "game of thrones"
      @TvonlineWrapper.search "24"
      @TvonlineWrapper.search "homeland"
      @TvonlineWrapper.search "person of interest"

      setTimeout =>
        expect(_.map @TvonlineWrapper.titles, (t) -> t.name).toContain "Person of Interest (2011)"
        done()
      , 5000
