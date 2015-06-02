class TopController < ApplicationController
  before_action :set_url, only: [:index]

  def index
    @video_titles   = "modern-family-2009" if @video_titles == nil
    @scripts_titles = "modern-family"      if @scripts_titles == nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @video_titles = params[:video_titles]
      @scripts_titles = params[:scripts_titles]

      if params[:commit] == "go1"
      then
        @tvonline_url = LibVideo.get_video_url_url(@video_titles, params[:season], params[:episode])
        @scripts_url = LibScripts.get_scripts_url(@scripts_titles, params[:season], params[:episode])
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
