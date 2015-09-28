describe "SpringfieldWrapper", ->

  beforeEach ->
    @SpringfieldWrapper = @model "SpringfieldWrapper"
    @makeDigestLoop()

  afterEach -> @clearDigestLoop()

  describe "#search", ->

    it "only updates #titles with the results of a final query", (done) ->

      @SpringfieldWrapper.search "modern family"
      @SpringfieldWrapper.search "game of thrones"
      @SpringfieldWrapper.search "24"
      @SpringfieldWrapper.search "vampire"
      @SpringfieldWrapper.search "person of interest"

      setTimeout =>
        expect(_.map @SpringfieldWrapper.titles, (t) -> t.name).toContain "Person of Interest"
        done()
      , 5000
