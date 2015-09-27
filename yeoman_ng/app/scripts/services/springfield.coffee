@app.service 'Springfield', ['Yql', (Yql) ->

  _baseUrl = "http://www.springfieldspringfield.co.uk"


  # String -> [Title]
  @search = (query) ->

    Yql.getHTML "#{_baseUrl}/tv_show_episode_scripts.php?search=#{query}"
    .then (JQhtml) ->

      JQhtml.find('.script-list-item').map ->
        name = $(this).text()
        url  = _baseUrl + $(this).attr('href')
        new Title name, url
      .toArray()


  @Title =
  class Title   # String, String
    constructor: (@name,  @url) ->

    # -> [Season]
    getSeasons: ->

      Yql.getHTML @url
      .then (JQhtml) =>

        quadruples =
        JQhtml.find('.season-episode-title').map ->
          href    = $(this).attr('href')
          {
            name         : $(this).text().match(/\-\ (.*)$/)[1]
            url          : _baseUrl + "/" + href
            seasonNumber : parseInt href.match(/\&episode\=s(\d*)/)[1]
            episodeNumber: parseInt href.match(/\&episode\=s\d*e(\d*)/)[1]
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
  class Season  # Number,         [Episode]
    constructor: (@seasonNumber, @episodes) ->


  @Episode =
  class Episode # String, String, Number
    constructor: (@name,  @url,   @episodeNumber) ->

    # -> (Html) String
    getSubtitles: ->

      Yql.getHTML @url
      .then (JQhtml) ->
        JQhtml.find("div.scrolling-script-container").html().split("<br>")
              .map((s) -> "<span> #{s.replace(/(\t|\n|\r)/gm, "").trim()} </span>")
              .join("<br>")
  @
]
