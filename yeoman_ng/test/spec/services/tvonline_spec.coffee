describe "Tvonline", ->

  beforeEach ->
    @Tvonline = @model "Tvonline"
    @makeDigestLoop()

    @exampleTitle   = new @Tvonline.Title "Modern Family (2009)"
                                        , "http://tvonline.tw/modern-family-2009/"

    @exampleEpisode = new @Tvonline.Episode "Strangers on a Treadmill"
                                          , "http://tvonline.tw/modern-family-2009/season-2-episode-4/"
                                          , 4

    @exampleVideo   = new @Tvonline.Video "videoweed"
                                        , "http://embed.videoweed.es/embed.php?v=278b5f277a994"


  afterEach -> @clearDigestLoop()


  describe "#search", ->

    it "", (done) ->

      @Tvonline.search "modern"
      .then (titles) =>
        # console.log JSON.stringify titles, null, 2
        expect     omitTrackers titles
        .toContain omitTracker  @exampleTitle

        done()


  describe "#Title", ->

    it "#getSeasons", (done) ->

      @exampleTitle.fetchSeasons()
      .then =>
        # console.log JSON.stringify @exampleTitle.seasons, null, 2
        expect     omitTrackers @exampleTitle.seasons[1].episodes
        .toContain omitTracker  @exampleEpisode

        done()


    it "#getSeasons (several timing)", (done) ->

      @exampleTitle.fetchSeasons()
      .then =>
        console.log "1"
        expect     omitTrackers @exampleTitle.seasons[1].episodes
        .toContain omitTracker  @exampleEpisode

        # TODO: this should be false.
        # I believe this miss behaviour is because of untriggered digest cycle of promiseTracker
        expect @exampleTitle.seasonsTracker.active()
        .toBe   true

        @exampleTitle.fetchSeasons()
        .then =>
          expect     omitTrackers @exampleTitle.seasons[1].episodes
          .toContain omitTracker  @exampleEpisode
          done()

      expect @exampleTitle.seasonsTracker.active()
      .toBe   true

      @exampleTitle.fetchSeasons()
      .then =>
        expect     omitTrackers @exampleTitle.seasons[1].episodes
        .toContain omitTracker  @exampleEpisode


  describe "#Episode", ->

    it "#getVideos", (done) ->

      @exampleEpisode.fetchVideos()
      .then =>
        # console.log JSON.stringify @exampleEpisode.videos, null, 2
        expect(@exampleEpisode.videos).toContain @exampleVideo
        done()


  describe "#convertVideoUrl", ->

    it "", ->

      examples = [
        {
          input:  "http://www.movshare.net/video/d97883416db5e"
          output: "http://embed.movshare.net/embed.php?v=d97883416db5e"
        }
        {
          input:  "http://www.nowvideo.sx/video/43ad0b148ea18"
          output: "http://embed.nowvideo.sx/embed.php?v=43ad0b148ea18"
        }
        {
          input:  "http://www.videoweed.es/file/5031f243de50e"
          output: "http://embed.videoweed.es/embed.php?v=5031f243de50e"
        }
        {
          input:  "http://www.thevideo.me/lvzxo0n1kh3z"
          output: "http://thevideo.me/embed-lvzxo0n1kh3z.html"
        }
        {
          input: "http://thevideo.me/tuuwzkn09qew"
          output: "http://thevideo.me/embed-tuuwzkn09qew.html"
        }
      ]

      _.each examples, (e) =>
        expect(@Tvonline.convertVideoUrl e.input).toEqual e.output
