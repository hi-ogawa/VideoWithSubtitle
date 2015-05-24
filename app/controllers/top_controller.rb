class TopController < ApplicationController
  before_action :set_url, only: [:index]

  def index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url

      # @scripts_text, @video_url

      if params[:commit] == "go1"
      then 
       @scripts_text = LibScripts.get_scripts_modern_family(params[:season], params[:episode])
       @video_url = LibVideo.get_video_url_modern_family(params[:season], params[:episode])
      else
        @scripts_text = LibScripts.get_scripts(params[:scripts_url])
        if params[:tvonline_url] == ""
        then @video_url = params[:video_url]
        else @video_url = LibVideo.get_video_url(params[:tvonline_url])
        end
      end

      # if params[:go1] == nil
      # @season  = params[:season]
      # @episode = params[:episode]



      # if params[:tvonline_url] == ""
      # then @video_url = params[:video_url]
      # else @video_url = LibVideo.get_video_url(params[:tvonline_url])
      # end

      # scripts_url = params[:scripts_url]
      # @scripts_text = LibScripts.get_scripts(scripts_url)
    end
end
