class TopController < ApplicationController
  before_action :set_url, only: [:index]

  def index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url

      if params[:commit] == "go1"
      then 
       @scripts_text = LibScripts.get_scripts_modern_family(params[:season], params[:episode])
       @video_url = LibVideo.get_video_url_modern_family(params[:season], params[:episode])
      else
        @scripts_text = LibScripts.get_scripts(params[:scripts_url])
        index = if params[:index] == ""
                then 0 
                else (params[:index]).to_i
                end
        @video_url = LibVideo.get_video_url(params[:tvonline_url], index)
      end
    end
end
