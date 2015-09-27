describe "Springfield", ->

  beforeEach ->
    @Springfield = @model "Springfield"
    @makeDigestLoop()

    @exampleTitle = new @Springfield.Title "Modern Family"
                                         , "http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=modern-family"

    @exampleEpisode =  new @Springfield.Episode "Pilot"
                                              , "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s01e01"
                                              , 1

  afterEach -> @clearDigestLoop()


  describe "#search", ->

    it "", (done) ->

      @Springfield.search "modern"
      .then (titles) =>
        # console.log JSON.stringify titles, null, 2
        expect(titles).toContain @exampleTitle
        done()


  describe "#Title", ->

    it "#getSeasons", (done) ->

      @exampleTitle.getSeasons()
      .then (seasons) =>
        # console.log JSON.stringify seasons, null, 2
        expect(seasons[0].episodes).toContain @exampleEpisode
        done()


  describe "#Episode", ->

    it "#getSubtitles", (done) ->

      @exampleEpisode.getSubtitles()
      .then (subs) ->
        # console.log JSON.stringify subs, null, 2
        expect(subs).toMatch "Kids, breakfast!  Kids?"
        done()
