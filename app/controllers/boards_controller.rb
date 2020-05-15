class BoardsController < ApplicationController
  before_action :authenticate_user!, only: [:my]
  before_action :check_authority, only: [:edit, :update, :destroy]
  before_action :set_board, only: [:edit, :update, :destroy]

  def index
    @board = Board.all
    @board = Board.page(params[:page]).per(6)
  end

  def new
    @board = Board.new
  end

  def create
    # @board = current_user.boards.new(board_params)
    @board = Board.new(board_params.merge(user_id: current_user.id))
    debugger
    if @board.save
      redirect_to my_boards_path, notice: 'create successfully!'
    else
      render :new
    end
  end

  def show
    # @board = current_user.boards.find_by(id: params[:id])
    @board = Board.find_by(id: params[:id])
  end

  def edit
  end

  def my
    @board = Board.where(user: current_user)
  end

  def update
    @board.update(board_params)

    if @board.save
      redirect_to my_boards_path, notice: 'update successfully!'
    else
      render :new
    end
  end

  def destroy
    @board.destroy
    redirect_to my_boards_path, notice: 'deleted!'
  end

  private
  def check_authority
    redirect_to board_path(id: params[:id]) if Board.find_by(id: params[:id]).user_id != current_user.id
  end
  
  def set_board
    # if Board.find_by(id: params[:id]).user_id == current_user.id
    # @board = current_user.boards.find_by(id: params[:id])
    @board = Board.find_by(id: params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :description, :language)
  end

end


