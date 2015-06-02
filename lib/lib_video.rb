require 'simple-rss'
require 'net/http'
require 'uri'

##
require 'open-uri'
require 'nokogiri'


search_url = "http://www.tvonline.tw/search.php?key=modern"
series_url = "http://www.tvonline.tw/modern-family-2009/"
episode_url = "http://www.tvonline.tw/modern-family-2009/season-3-episode-15/"

module LibVideo
  
  # def self.search(inq) # return titles
  #   url = "http://www.tvonline.tw/search.php?key=" + CGI.escape(inq)
  #   xs = Nokogiri::HTML(open(url)) . css(".found a")
  #   xs.map do |a|
  #     a.attr("href").match(/(.*)\//)[1]
  #   end
  # end

  def self.get_video_url_url(name, s, e)
    url = "http://www.tvonline.tw/" + name + "/season-" + s + "-episode-" + e + "/"
    return url
  end


  def self.get_video_url(url, i) # videoweed or movshare (ignoreing i)
    return "" if url == nil
    doc = Nokogiri::HTML(open(url))
    # return (doc.css("#linkname_nav a")[i].attr("onclick")).match(/'(.*)'/)[1]
    doc.css("#linkname_nav a").each do |a|
      if a.text == "videoweed"
        l = a.attr("onclick").match(/'(.*)'/)[1]
        if l.match(/embed/)
          return l
        else
          return "http://embed.videoweed.es/embed.php?v=" + l.match(/file\/(.*)/)[1]
        end
      end
      if a.text == "movshare"
        return a.attr("onclick").match(/'(.*)'/)[1]
      end
    end
  end

  def self.get_video_url_modern_family(s, e)
    url = "http://www.tvonline.tw/modern-family-2009/season-" + s + "-episode-" + e + "/"
    return url
  end
end
