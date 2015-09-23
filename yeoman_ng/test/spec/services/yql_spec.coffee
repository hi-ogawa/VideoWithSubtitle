describe "Yql", ->

  beforeEach ->
    @Yql = @model "Yql"

  describe "#getHTML", ->

    it "", (done) ->

      JQhtml = null
      exampleUrl = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s06e08"

      @Yql.getHTML exampleUrl
      .then  (res) -> JQhtml = res

      @waitForQ (-> JQhtml isnt null), 3000
      .then ->
        console.log JQhtml.text()
        done()
      .catch ->
        done()
        throw "Yql.getHTML didn't return in 3 sec"
