require 'simple-rss'
require 'net/http'
require 'uri'

##
require 'open-uri'
require 'nokogiri'


search_url = "http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=modern"
series_url = "http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=modern-family"
episode_url = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s03e12"


module LibScripts

  # def self.search(inq) # return titles
  #   url = "http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search=" + CGI.escape(inq)
  #   xs = Nokogiri::HTML(open(url)) . css(".script-list-item")
  #   xs.map do |a|
  #     a.attr("href").match(/.*tv-show=(.*)/)[1]
  #   end
  # end

  def self.get_scripts_url(name, s, e)
    s = "0" + s if s.length == 1
    e = "0" + e if e.length == 1
    url = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=" + name + "&episode=s" + s + "e" + e
    return url
  end

  def self.get_scripts(url)
    return "" if url == nil
    x = Nokogiri::HTML(open(url)) . css("div.scrolling-script-container")
    str = (x.children.map do |n|
             if n.name == "br"
             then "</span> <br> <span>"
             else n.text
             end
           end).join
    self.to_utf8("<span>" + str + "</span>")
  end

  def self.get_scripts_modern_family(s, e)
    s = "0" + s if s.length == 1
    e = "0" + e if e.length == 1
    url = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s" + s + "e" + e
    return url
  end

  def self.to_utf8(str)
    str = str.force_encoding("UTF-8")
    return str if str.valid_encoding?
    str = str.force_encoding("BINARY")
    str.encode("UTF-8", invalid: :replace, undef: :replace)
  end
end

