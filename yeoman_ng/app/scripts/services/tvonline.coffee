@app.service 'Tvonline', ['Yql', (Yql) ->

  _baseUrl = "http://tvonline.tw"


  # String -> [Title]
  @search = (query) ->

    Yql.getHTML "#{_baseUrl}/search.php?key=#{encodeURIComponent(query)}"
    .then (JQhtml) ->

      JQhtml.find('.found a').map ->
        name = $(this).text()
        url  = _baseUrl + "/" + $(this).attr('href')
        new Title name, url
      .toArray()


  @Title =
  class Title   # String, String
    constructor: (@name,  @url) ->

    # -> [Season]
    getSeasons: ->

      Yql.getHTML @url
      .then (JQhtml) ->

        quadruples =
        JQhtml.find('.Season ul a').map ->
          href    = $(this).attr('href')
          {
            name         : $(this).text().match(/\-\ (.*)$/)[1]
            url          : _baseUrl + href
            seasonNumber : parseInt href.match(/season-([^\-]*)-/)[1]
            episodeNumber: parseInt href.match(/episode-(.*)\/$/)[1]
          }
        .toArray()

        _(quadruples)
        .groupBy (q) -> q.seasonNumber
        .pairs()
        .map (seasonNumber_episodes) ->
          new Season seasonNumber_episodes[0]
                    , _.map seasonNumber_episodes[1], (q) ->
                        new Episode q.name, q.url, q.episodeNumber
        .value()


  @Season =
  class Season  # Number,        [Episode]
    constructor: (@seasonNumber, @episodes) ->


  @Episode =
  class Episode # String, String, Number
    constructor: (@name,  @url,   @episodeNumber) ->

    # -> [Video]
    getVideos: ->

      Yql.getHTML @url
      .then (JQhtml) ->

        JQhtml.find('#linkname_nav a').map ->
          name = $(this).text()
          url  = $(this).attr('onclick').match(/'(.*)'/)[1]
          new Video name, url
        .toArray()


  @Video =
  class Video   # String, String
    constructor: (@name, @url) ->
      @url = convertVideoUrl @url

  @convertVideoUrl =
  convertVideoUrl = (url) ->
    tmp = url
    _.each _.values(_embedPatterns), (p) ->
      r = new RegExp p.nonEmbedPattern
      tmp = url.replace r, p.embedUrl if url.match r
    return tmp

  _embedPatterns =
    movshare:
      nonEmbedPattern: "http:\/\/www.movshare.net\/video\/(.*)"
      embedUrl: (match, id) -> "http://embed.movshare.net/embed.php?v=#{id}"
    nowvideo:
      nonEmbedPattern: "http://www.nowvideo.sx/video/(.*)"
      embedUrl: (match, id) -> "http://embed.nowvideo.sx/embed.php?v=#{id}"
    videoweed:
      nonEmbedPattern: "http://www.videoweed.es/file/(.*)"
      embedUrl: (match, id) -> "http://embed.videoweed.es/embed.php?v=#{id}"
    thevideo1:
      nonEmbedPattern: "http://www.thevideo.me/(.*)"
      embedUrl: (match, id) -> "http://thevideo.me/embed-#{id}.html"
    thevideo2:
      nonEmbedPattern: "http://thevideo.me/(.*)"
      embedUrl: (match, id) -> "http://thevideo.me/embed-#{id}.html"

  # TODO: extend Video class and add check if url is available, like:
  # class Videoweed extends Video
  #   # -> Boolean
  #   isAvailabe: -> ...

  @
]
