describe "Springfield", ->

  beforeEach ->
    @Springfield = @model "Springfield"
    @makeDigestLoop()

    @exampleTitle = new @Springfield.Title "Modern Family"
                                         , "http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=modern-family"

    @exampleEpisode =  new @Springfield.Episode "Pilot"
                                              , "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s01e01"
                                              , 1
                                              , 1

  afterEach -> @clearDigestLoop()


  describe "#search", ->

    it "", (done) ->

      @Springfield.search "modern"
      .then (titles) =>
        expect(titles).toContain @exampleTitle
        done()


  describe "#Title", ->

    it "#getEpisodes", (done) ->

      @exampleTitle.getEpisodes()
      .then (episodes) =>
        expect(episodes).toContain @exampleEpisode
        done()


  describe "#Episode", ->

    it "#getSubtitles", (done) ->

      @exampleEpisode.getSubtitles()
      .then (subs) ->
        expect(subs).toMatch "Kids, breakfast!  Kids?"
        done()
