class CardsController < ApplicationController
  def new
    @card = Card.new
  end

  def create
    @card = Board.find(params[:board_id]).cards.build(card_params)
    
    if @card.save
      redirect_to board_path(params[:board_id]), notice: 'create successfully!'
    else
      render :new
    end
  end

  def edit
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
  end

  def update
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
    @card.update(card_params)
    if @card.save
      redirect_to board_path(params[:board_id]), notice: 'update successfully!'
    else
      render :new
    end
  end



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
