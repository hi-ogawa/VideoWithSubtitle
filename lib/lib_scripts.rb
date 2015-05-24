require 'simple-rss'
require 'net/http'
require 'uri'

##
require 'open-uri'
require 'nokogiri'


test_url = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s03e12"

module LibScripts
  def self.get_scripts(url)
    return "" if url == nil
    x = Nokogiri::HTML(open(url)) . css("div.scrolling-script-container")
    (x.children.map do |n|
       if n.name == "br"
       then "<br>"
       else n.text
       end
     end).join
  end

  def self.get_scripts_modern_family(s, e)
    s = "0" + s if s.length == 1
    e = "0" + e if e.length == 1
    url = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=modern-family&episode=s" + s + "e" + e
    return url
  end
end
