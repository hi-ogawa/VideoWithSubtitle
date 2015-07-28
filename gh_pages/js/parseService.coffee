parseService = angular.module 'parseService', []

# this depends on jQuery
parseService.factory 'parsers', [ () ->

  parsers = {}

  # return search results from
  # http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=modern
  parsers.getTitlesFromSpringfield = (html) ->
    jQitems = $(html).find('.script-list-item').map ->
      val = $(this).attr('href')
      name = $(this).text()
      {'val': val, 'name': name}
    jQitems.toArray()


  # return search results from
  # http://tvonline.tw/search.php?key=modern
  parsers.getTitlesFromTVOnline = (html) ->
    jQitems = $(html).find('.found a').map ->
      val = $(this).attr('href')
      name = $(this).text()
      {'val': val, 'name': name}
    jQitems.toArray()


  # return available episodes from
  # http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=[name]
  parsers.getEpisodesFromSpringfield = (html) ->
    jQitems = $(html).find('.season-episode-title').map ->
      val = $(this).attr('href')
      s = parseInt(val.match(/\&episode\=s(\d*)/)[1]).toString()
      e = parseInt(val.match(/\&episode\=s\d*e(\d*)/)[1]).toString()
      name = $(this).text().match(/\-\ (.*)$/)[1]
      {'val': val, 'name': "s#{s} e#{e} - #{name}"}
    jQitems.toArray()


  # return available episodes from
  # http://tvonline.tw/modern-family-2009/
  parsers.getEpisodesFromTVOnline = (html) ->
    jQitems = $(html).find('.Season ul a').map ->
      val = $(this).attr('href')
      s = val.match(/season-([^\-]*)-/)[1]
      e = val.match(/episode-(.*)\/$/)[1]
      name = $(this).text().match(/\-\ (.*)$/)[1]
      {'val': val, 'name': "s#{s} e#{e} - #{name}"}
    jQitems.toArray()

   
  # return available videos from
  # http://tvonline.tw/modern-family-2009/season-1-episode-1/
  parsers.getEmbedVideos = (html) ->
    jQitems = $(html).find('#linkname_nav a').map ->
      val  = $(this).attr('onclick').match(/'(.*)'/)[1]
      name = $(this).text()
      {'val': val, 'name': name}
    jQitems.toArray()


  # return subtitle
  # http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s01e02
  parsers.getSubtitle = (html) ->
    # $(html).find('.scrolling-script-container').text()
    scripts = $(html).find("div.scrolling-script-container").html().split("<br>")
	                   .map((s) -> "<span> #{s.replace(/(\t|\n|\r)/gm, "").trim()} </span>")
		                 .join("<br>")
    scripts

  parsers
]
