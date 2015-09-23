describe "Springfield", ->

  beforeEach ->
    @Springfield = @model "Springfield"

  describe "#search", ->

    it "", (done) ->

      titles = null

      @Springfield.search "modern"
      .then (res) -> titles = res
      
      @waitForQ (-> titles isnt null), 2000
      .then ->
        console.log titles
        done()
      .catch ->
        done()
        throw "Springfield.search didn't return in 3 sec"
