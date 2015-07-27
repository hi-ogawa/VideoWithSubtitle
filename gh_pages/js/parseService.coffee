parseService = angular.module 'parseService', []

# this depends on jQuery
parseService.factory 'parsers', [ () ->

  parsers = {}

  # return search results from
  # http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=modern
  parsers.getTitlesFromSpringfield = (htmlStr) ->
    html = $.parseHTML htmlStr
    jQitems = $(html).find('.script-list-item').map ->
      val = $(this).attr('href').match(/.*tv-show=(.*)/)[1]
      name = $(this).text()
      {'val': val, 'name': name}
    jQitems.toArray()

  parsers
]
