@app.service 'Springfield', ['Yql', (Yql) ->

  _baseUrl = "http://www.springfieldspringfield.co.uk"

  @search = (query) ->
    Yql.getHTML "#{_baseUrl}/tv_show_episode_scripts.php?search=#{query}"
    .then (JQhtml) ->
      JQitems = JQhtml.find('.script-list-item').map ->
        val = $(this).attr('href')
        name = $(this).text()
        {'val': val, 'name': name}
      JQitems.toArray()
  @
]  
