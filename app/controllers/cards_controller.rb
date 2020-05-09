class CardsController < ApplicationController
  def new
    @card = Card.new
  end

  def create
    @card = Board.find(params[:board_id]).cards.build(card_params)
    puts @card
    
    if @card.save
      redirect_to board_path(params[:board_id]), notice: 'create successfully!'
    else
      render :new
    end
  end

  def 



  private

  def card_params
    params.require(:card).permit(:title,
                                 :description,
                                 :default_code,
                                 :answer,
                                 :level,
                                 :tags,
                                 :order,
                                 :board_id)
  end

end
