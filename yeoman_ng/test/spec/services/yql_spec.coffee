describe "Yql", ->

  beforeEach ->
    @Yql = @model "Yql"
    @makeDigestLoop()

  afterEach ->
    @clearDigestLoop()


  describe "#getHTML", ->

    it "", (done) ->

      @Yql.getHTML "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s01e01"
      .then  (JQhtml) ->
        expect(JQhtml.text()).toMatch "Kids"
        done()
