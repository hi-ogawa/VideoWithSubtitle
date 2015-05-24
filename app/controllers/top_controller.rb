class TopController < ApplicationController
  before_action :set_url, only: [:index]

  def index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url

      if params[:commit] == "go1"
      then
        @scripts_url = LibScripts.get_scripts_modern_family(params[:season], params[:episode])
        @tvonline_url = LibVideo.get_video_url_modern_family(params[:season], params[:episode])
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
