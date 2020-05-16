class BoardsController < ApplicationController
  before_action :authenticate_user!, only: [:my, :new, :edit, :update, :destroy]
  before_action :check_authority, only: [:new, :edit, :update, :destroy]
  before_action :set_board, only: [:show, :edit, :update, :destroy]

  def index
    @boards = Board.all
    @boards = Board.page(params[:page]).per(6)
    if params[:search]
      @search_term = params[:search]
      @boards = @boards.search_by(@search_term)
    end
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params.merge(user_id: current_user.id))
    if @board.save
      redirect_to board_path(@board.id), notice: 'create successfully!'
    else
      render :new
    end
  end

  def show
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
    @board = Board.find_by(id: params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :description, :language)
  end

end


