describe "Tvonline", ->

  beforeEach ->
    @Tvonline = @model "Tvonline"
    @makeDigestLoop()

    @exampleTitle   = new @Tvonline.Title "Modern Family (2009)"
                                     , "http://tvonline.tw/modern-family-2009/"

    @exampleEpisode = new @Tvonline.Episode "Strangers on a Treadmill"
                                         , "http://tvonline.tw/modern-family-2009/season-2-episode-4/"
                                         , 2
                                         , 4
   
    @exampleVideo   = new @Tvonline.Video "videoweed"
                                        , "http://embed.videoweed.es/embed.php?v=278b5f277a994"


  afterEach -> @clearDigestLoop()


  describe "#search", ->
    
    it "", (done) ->

      @Tvonline.search "modern"
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

    it "#getVideos", (done) ->

      @exampleEpisode.getVideos()
      .then (videos) =>
        expect(videos).toContain @exampleVideo
        done()
