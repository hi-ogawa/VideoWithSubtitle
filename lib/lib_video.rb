require 'simple-rss'
require 'net/http'
require 'uri'

##
require 'open-uri'
require 'nokogiri'


test_url = "http://www.tvonline.tw/modern-family-2009/season-3-episode-15/"

module LibVideo
  def self.get_video_url(url, i)
    return "" if url == nil
    doc = Nokogiri::HTML(open(url))
    return (doc.css("#linkname_nav a")[i].attr("onclick")).match(/'(.*)'/)[1]
  end

  def self.get_video_url_modern_family(s, e)
    url = "http://www.tvonline.tw/modern-family-2009/season-" + s + "-episode-" + e + "/"
    return self.get_video_url(url, 0)
  end
end
