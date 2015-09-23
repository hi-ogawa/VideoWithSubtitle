@app.service 'Springfield', ['Yql', (Yql) ->

  _baseUrl = "http://www.springfieldspringfield.co.uk"

  @Title =
  class Title   # String, String
    constructor: (@name,  @url) ->

    # -> [Episode]
    getEpisodes: ->

      Yql.getHTML @url
      .then (JQhtml) ->

        JQhtml.find('.season-episode-title').map ->
          href    = $(this).attr('href')
          name    = $(this).text().match(/\-\ (.*)$/)[1]
          url     = _baseUrl + "/" + href
          season  = parseInt href.match(/\&episode\=s(\d*)/)[1]
          episode = parseInt href.match(/\&episode\=s\d*e(\d*)/)[1]
          new Episode name, url, season, episode
        .toArray()


  @Episode =
  class Episode # String, String, Number,  Number
    constructor: (@name,  @url,   @season, @episode) ->

    # -> (Html) String
    getSubtitles: ->

      Yql.getHTML @url
      .then (JQhtml) ->
        JQhtml.find("div.scrolling-script-container").html().split("<br>")
              .map((s) -> "<span> #{s.replace(/(\t|\n|\r)/gm, "").trim()} </span>")
              .join("<br>")


  # String -> [Title]
  @search = (query) ->

    Yql.getHTML "#{_baseUrl}/tv_show_episode_scripts.php?search=#{query}"
    .then (JQhtml) ->

      JQhtml.find('.script-list-item').map ->
        name = $(this).text()
        url  = _baseUrl + $(this).attr('href')
        new Title name, url
      .toArray()
  @
]
