class CardsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  before_action :find_board, except: [:list]
  before_action :find_card, only: [:edit, :show, :update, :destroy, :solve]
  before_action :build_card, only: [:index, :new, :create]
  before_action :get_code, only: [:create, :update]
  before_action :docker_exec_service, only: [:create, :update, :solve]
  before_action :exec_and_get_result, only: [:create, :update]

  before_action :check_authority, only: [:new, :edit, :update, :destroy]

  def index
    redirect_to new_board_card_path
  end

  def list
    @q = Card.ransack(params[:q])
    @cards = @q.result
               .includes(:board)
               .page(params[:page]).per(10)
  end
  
  def new
    @options = Card::TAGS
    @card.assign_attributes(test_code: [''], hints: [''])
  end

  def create
    @options = Card::TAGS
    if @docker_exec_service.fail?
      error_message
      attr_params = card_params.merge(result: @result)
      @card.assign_attributes(attr_params)
      return render :new
    else
      attr_params = card_params.merge(result: save_type(@result))
      @card.assign_attributes(attr_params)
      if params[:commit] == "送出" && @card.save
        redirect_to board_card_path(board_id: @board.id, id: @card.id), notice: '成功建立題目！'
      else
        render :new
      end
    end
  end

  def edit
    @options = Card::TAGS
  end

  def update
    @options = Card::TAGS
    if @docker_exec_service.fail?
      error_message
      attr_params = card_params.merge(result: @result)
      @card.assign_attributes(attr_params)
      return render :edit
    else
      attr_params = card_params.merge(result: save_type(@result))
      @card.assign_attributes(attr_params)
      if params[:commit] == "送出" && @card.update(attr_params)
        redirect_to board_card_path(board_id: @board.id, id: @card.id), notice: '成功修改題目！'
      else
        render :edit
      end
    end
  end

  def destroy
    if @card.destroy
      @board.cards.order(:updated_at).each_with_index do |card, idx|
        cur_order = idx + 1
        card.update(order: cur_order) if card.order != cur_order 
      end
      redirect_to board_path(@board), notice: '刪除成功！'
    else
      redirect_to board_path(@board), alert: '已有解題紀錄，刪除失敗！'
    end
  end

  def show
    @solved_records = @card.records.with_solved
    if @board.user == current_user
      render 'card_questioner'      
    else
      if current_user.present?
        @record = @card.records.find_by(user_id: current_user.id)
        if @record.present? && @record.solved
          render 'card_solved'
        else
          render_new_solving
        end  
      else
        render_new_solving
      end
    end
  end

  def solve
    @solved_cards = @card.records.with_solved
    @test_code = [@card.test_code[0]]
    @docker_exec_service.code = params[:record][:code]
    @docker_exec_service.test_code = @card.test_code
    exec_and_get_result
    error_message if @docker_exec_service.fail?

    @record = @card.records.find_by(user_id: current_user.id)
    if @record.nil?
      @record = current_user.records.new(card_id: @card.id, code: @card.default_code)
    end
    @record.assign_attributes(record_params)

    if params[:commit] == "送出"
      comparer_service
      @comparer_service.criteria = compare_type(@card.result)
      @comparer_service.value = @result
      
      @record.solved = @comparer_service.run
      @record.save
      
      if @record.solved
        flash[:notice] = "恭喜答對！"
        redirect_to board_card_path
      else
        print_true
        flash[:alert] = "錯誤！尚有 #{@comparer_service.result.count(false)} 筆測資未通過"
        render 'card_solving'
      end
    else
      @result = [@result.first]
      render 'card_solving'
    end 
  end

  private
  def error_message
    if @docker_exec_service.timeout?
      flash[:alert] = "Timeout!"
    elsif @docker_exec_service.result.nil?
      flash[:alert] = "解答 / 測試資料 請勿空白"
    else
      @error, @result = @result, ""
    end
  end

  def docker_exec_service
    @docker_exec_service ||= (
      case @board.language
      when "Ruby"
        DockerExec::RubyService
      when "JavaScript"
        DockerExec::JsService
      when "Python"
        DockerExec::PythonService
      end
    ).new(@code, @test_code)
  end

  def exec_and_get_result
    @docker_exec_service.run
    @result = @docker_exec_service.result
  end

  def get_code
    @code = params[:card][:answer]
    @test_code = params[:card][:test_code]
  end

  def comparer_service
    @comparer_service ||= Comparer.new(@criteria, @value) 
  end

  def print_true
    if @comparer_service.index <= 0
      @test_code = [@card.test_code[0]]
      @result = [@result.first]
    else
      @result = [*0..@comparer_service.index].map{ |e|
        @result[e]
      }
      @test_code = [*0..@comparer_service.index].map{ |e|
        @card.test_code[e]
      }
    end
  end

  def check_authority
    redirect_to board_path(id: @board.id), alert: 'check authority error! not owner!' if @board.user_id != current_user.id
  end

  def render_new_solving
    @record = Record.new(card_id: @card.id, code: @card.default_code)
    @test_code = [@card.test_code[0]]
    render 'card_solving'
  end

  def save_type(raw)
    raw.map{ |e| JSON.generate(e) }
  end

  def compare_type(raw)
    raw.map{ |e| JSON.parse(e) }
  end

  def card_params
    params.require(:card).permit(:title,
                                 :description,
                                 :default_code,
                                 :answer,
                                 :level,
                                 :order,
                                 :board_id,
                                {:tags=>[]},
                                 :result=>[],
                                 :hints=>[],
                                 :test_code=>[])
  end

  def record_params
    params.require(:record).permit(:code)
  end

  def find_board
    @board = Board.find(params[:board_id])
  end

  def find_card
    @card = @board.cards.find(params[:id])
  end

  def build_card
    @card = @board.cards.new
  end
end