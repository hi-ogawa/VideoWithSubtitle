describe "Springfield", ->

  beforeEach ->
    @Springfield = @model "Springfield"
    @makeDigestLoop()

  afterEach -> @clearDigestLoop()


  describe "#search", ->

    it "", (done) ->

      @Springfield.search "modern"
      .then (titles) =>
        expect(titles).toContain new @Springfield.Title "Modern Family", "http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=modern-family"
        done()


  describe "#Title", ->

    it "#getEpisodes", (done) ->

      new @Springfield.Title "Modern Family", "http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=modern-family"
      .getEpisodes()
      .then (episodes) ->
        expect(episodes[28].name).toEqual    "Unplugged"
        expect(episodes[28].url).toEqual     "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s02e05"
        expect(episodes[28].season).toEqual  2
        expect(episodes[28].episode).toEqual 5
        done()


  describe "#Episode", ->

    it "#getSubtitles", (done) ->

      new @Springfield.Episode "Pilot"
                             , "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s01e01"
                             , 1
                             , 1
      .getSubtitles()
      .then (subs) ->
        expect(subs).toMatch "Kids, breakfast!  Kids?"
        done()
