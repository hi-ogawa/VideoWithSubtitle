root = exports ? this


# cross origin html request with YQL
root.getCrossHTML = (url, callback) ->

  yql = "http://query.yahooapis.com/v1/public/yql?q=" +
        encodeURIComponent("select * from html where url='#{url}'") +
        "&format=xml&callback=?" 

  # $.getJSON yql, (data) ->
  #   callback(data.results[0])

  $.ajax
      dataType: 'json'
      url: yql
      success: (data) -> callback(data.results[0])


# return search results from
# http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=[name]
root.getTitlesFromSpringfield = (name, callback) ->

  url = 'http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=' +
         encodeURIComponent(name)

  getCrossHTML url, (htmlStr) ->
    html = $.parseHTML htmlStr
    jQitems = $(html).find('.script-list-item').map ->
      val = $(this).attr('href').match(/.*tv-show=(.*)/)[1]
      name = $(this).text()
      {'val': val, 'name': name}
    callback jQitems.toArray()



# return available episodes from
# http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=[name]
root.getEpisodesFromSpringfield = (name, callback) ->

  url = 'http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=' + name

  getCrossHTML url, (htmlStr) ->
    html = $.parseHTML htmlStr
    jQitems = $(html).find('.season-episode-title').map ->
      val = $(this).attr('href')
      s = parseInt(val.match(/\&episode\=s(\d*)/)[1]).toString()
      e = parseInt(val.match(/\&episode\=s\d*e(\d*)/)[1]).toString()
      name = $(this).text().match(/\-\ (.*)$/)[1]
      {'val': val, 'name': "s#{s} e#{e} - #{name}"}
    callback jQitems.toArray()

# return subtitle
# http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s01e02
root.getSubtitle = (path, callback) ->

  url = 'http://www.springfieldspringfield.co.uk/' + path

  getCrossHTML url, (htmlStr) ->
    html = $.parseHTML htmlStr
    callback $(html).find('.scrolling-script-container').text()



# return search results from
# http://tvonline.tw/search.php?key=modern
root.getTitlesFromTVOnline = (name, callback) ->

  url = 'http://tvonline.tw/search.php?key=' + encodeURIComponent(name)

  getCrossHTML url, (htmlStr) ->
    html = $.parseHTML htmlStr
    jQitems = $(html).find('.found a').map ->
      val = $(this).attr('href').match(/(.*)\//)[1]
      name = $(this).text()
      {'val': val, 'name': name}
    callback jQitems.toArray()



# return available episodes from
# http://tvonline.tw/modern-family-2009/
root.getEpisodesFromTVOnline = (name, callback) ->

  url = "http://tvonline.tw/#{name}/"

  getCrossHTML url, (htmlStr) ->
    html = $.parseHTML htmlStr

    jQitems = $(html).find('.Season ul a').map ->
      val = $(this).attr('href')
      s = val.match(/season-([^\-]*)-/)[1]
      e = val.match(/episode-(.*)\/$/)[1]
      name = $(this).text().match(/\-\ (.*)$/)[1]
      {'val': val, 'name': "s#{s} e#{e} - #{name}"}
    callback jQitems.toArray()

# return available videos from
# http://tvonline.tw/modern-family-2009/season-1-episode-1/
root.getEmbedVideos = (name, callback) ->

  url = "http://tvonline.tw/#{name}"

  getCrossHTML url, (htmlStr) ->
    html = $.parseHTML htmlStr

    jQitems = $(html).find('#linkname_nav a').map ->
      val  = $(this).attr('onclick').match(/'(.*)'/)[1]
      name = $(this).text()
      {'val': val, 'name': name}
    callback jQitems.toArray()
