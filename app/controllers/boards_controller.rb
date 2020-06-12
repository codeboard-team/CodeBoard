class BoardsController < ApplicationController

  before_action :authenticate_user!, only: [:my, :new, :edit, :update, :destroy]
  before_action :find_board, only: [:show, :edit, :update, :destroy]
  before_action :build_board, only: [:new, :create]
  before_action :check_authority, only: [:edit, :update, :destroy]

  def index
    @q = Board.joins(:cards).distinct('boards.id').ransack(params[:q])
    @boards = @q.result
                .page(params[:page]).per(6)
  end
  
  def new
  end

  def create
    @board.assign_attributes(board_params)

    if @board.save
      redirect_to board_path(@board.id), notice: '新增成功！'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def my
    @board = current_user.boards
    redirect_to new_board_path if @board.count == 0
  end

  def update
    if @board.update(board_params)
      redirect_to my_boards_path, notice: '更新成功！'
    else
      render :edit
    end
  end

  def destroy
    if @board.destroy
      redirect_to my_boards_path, notice: '刪除成功！'
    else
      redirect_to my_boards_path, alert: '已有解題紀錄，刪除失敗！'
    end
  end

  private
  def check_authority
    redirect_to board_path(id: @board.id), notice: '權限不足，您不是擁有者' if @board.user_id != current_user.id
  end
  
  def find_board
    @board = Board.find(params[:id])
  end

  def build_board
    @board = current_user.boards.new
  end

  def board_params
    params.require(:board).permit(:title, :description, :language)
  end

end


