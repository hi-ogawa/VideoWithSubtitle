class TopController < ApplicationController
  before_action :set_url, only: [:index]

  def index
  end

  def record # coming ajax base post -> screen shots -> record data
    vals = vocab_params
    vals[:picture] = Time.now.strftime("%Y%m%d_%H%M%S.png")
    vals[:season]  = vals[:season].to_i
    vals[:episode] = vals[:episode].to_i
    Vocab.create(vals)
    `/usr/sbin/screencapture #{Rails.root}/public/screenshots/#{vals[:picture]}`
    redirect_to "/"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      
    end
    
    def vocab_params
      params.require(:vocab).permit(:title, :season, :episode, :word, :sentence)
    end
  end
