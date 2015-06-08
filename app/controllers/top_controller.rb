class TopController < ApplicationController
  # before_action :set_url, only: [:index]

  def index
  end

  def record # coming ajax base post -> screen shots -> record data
    returns = vocab_params
    pic = Time.now.strftime("%Y%m%d_%H%M%S.png")
    `/usr/sbin/screencapture #{Rails.root}/public/screenshots/#{pic}`

    rb_t = Title.find_or_create_by(:name => returns[:title])
    rb_t_s_e = rb_t.numbers.find_or_create_by(:season  => returns[:season].to_i,
                                              :episode => returns[:episode].to_i)
    rb_t_s_e.vocabs.create(:word     => returns[:word],
                           :sentence => returns[:sentence],
                           :picture  => pic)

    redirect_to "/"
  end

  def view
    # @titles = Title.all
    # @numbers = Number.all
    # @vocabs = Vocab.all
  end

  def ajax_titles
    render :xml => Title.all.map{|t| {id: t.id, name: t.name} }.reverse
  end

  def ajax_numbers
    ns = Title.find( params[:returns][:title] ).numbers.reverse
    render :xml => ns.map{|n| {id: n.id, season: n.season, episode: n.episode}}
  end

  def ajax_vocabs
    vs = Number.find( params[:returns][:number] ).vocabs.reverse
    render :xml => vs.map{|v| {id: v.id, word: v.word,
                               sentence: v.sentence, picture: v.picture}}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_url
    # end
    
    def vocab_params
      params.require(:returns).permit(:title, :season, :episode, :word, :sentence)
    end
  end
