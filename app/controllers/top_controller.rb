class TopController < ApplicationController
  before_action :set_url, only: [:index]

  def index
    # @titles_video = [] if @titles_video == nil
    # @titles_scripts = [] if @titles_scripts == nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      if params[:commit] == "go3"
      then
        @titles_video = LibVideo.search(params[:title_inquery])
        @titles_scripts = LibScripts.search(params[:title_inquery])
        return
      end

      if params[:commit] == "go1"
      then
        params[:title_video] = "modern-family-2009" if params[:title_video] == nil
        params[:title_scripts] = "modern-family" if params[:title_scripts] == nil
        @tvonline_url = LibVideo.get_video_url_url(params[:title_video], params[:season], params[:episode])
        @scripts_url = LibScripts.get_scripts_url(params[:title_scripts], params[:season], params[:episode])
        @index = 0
      else
        @scripts_url = params[:scripts_url]
        @tvonline_url = params[:tvonline_url]
        @index = if params[:index] == ""
                 then 0 
                 else (params[:index]).to_i
                 end
      end
      @scripts_text = LibScripts.get_scripts(@scripts_url)
      @video_url = LibVideo.get_video_url(@tvonline_url, @index)
    end
  end
