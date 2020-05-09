class BoardsController < ApplicationController

  def index
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.new(board_params)

    if @board.save
      redirect_to boards_path, notice: 'create successfully!'
    else
      render :new
    end

  end







  private
  def board_params
    params.require(:board).permit(:title, :description, :language)
  end

end
