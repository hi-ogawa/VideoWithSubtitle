@app.service 'Tvonline', ['Yql', (Yql) ->

  _baseUrl = "http://tvonline.tw"


  # String -> [Title]
  @search = (query) ->

    Yql.getHTML "#{_baseUrl}/search.php?key=#{query}"
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

  # TODO: extend Video class and add check if url is available, like:
  # class Videoweed extends Video
  #   # -> Boolean
  #   isAvailabe: -> ...

  @
]
