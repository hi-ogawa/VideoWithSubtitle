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

    # -> [Episode]
    getEpisodes: ->

      Yql.getHTML @url
      .then (JQhtml) ->

        JQhtml.find('.Season ul a').map ->
          href    = $(this).attr('href')
          name    = $(this).text().match(/\-\ (.*)$/)[1]
          url     = _baseUrl + href
          season  = parseInt href.match(/season-([^\-]*)-/)[1]
          episode = parseInt href.match(/episode-(.*)\/$/)[1]
          new Episode name, url, season, episode
        .toArray()


  @Episode =
  class Episode # String, String, Number,  Number
    constructor: (@name,  @url,   @season, @episode) ->

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
