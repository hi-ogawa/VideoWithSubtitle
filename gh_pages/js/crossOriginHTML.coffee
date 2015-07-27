getCrossHTML = (url, callback) ->

  yql = "http://query.yahooapis.com/v1/public/yql?q=" +
        encodeURIComponent("select * from html where url='#{url}'") +
        "&format=xml&callback=?" 

  $.getJSON yql, (data) ->
    callback(data.results[0])



getTitlesFromSpringfield = (name, callback) ->

  # ex. http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=modern
  url = 'http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=' +
         encodeURIComponent(name)

  getCrossHTML url, (htmlStr) ->
    html = $.parseHTML htmlStr
    jQitems = $(html).find('.script-list-item').map ->
      val = $(this).attr("href").match(/.*tv-show=(.*)/)[1]
      name = $(this).text()
      {'val': val, 'name': name}
    callback jQitems.toArray()



getTitlesFromTVOnline = (name, callback) ->

  # ex. http://tvonline.tw/search.php?key=modern
  url = 'http://tvonline.tw/search.php?key=' + encodeURIComponent(name)

  getCrossHTML url, (htmlStr) ->
    html = $.parseHTML htmlStr
    jQitems = $(html).find(".found a").map ->
      val = $(this).attr("href").match(/(.*)\//)[1]
      name = $(this).text()
      {'val': val, 'name': name}
    callback jQitems.toArray()



root = exports ? this

root.getCrossHTML = getCrossHTML
root.getTitlesFromSpringfield = getTitlesFromSpringfield
root.getTitlesFromTVOnline = getTitlesFromTVOnline
