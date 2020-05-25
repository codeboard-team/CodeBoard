class CardsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  before_action :find_board, except: [:index]
  before_action :find_card, only: [:edit, :show, :update, :destroy, :solve]
  before_action :build_card, only: [:new, :create]

  before_action :check_authority, only: [:new, :edit, :update, :destroy]

  def index 
    @cards = Card.page(params[:page]).per(5)
  end
  
  def new
    @card.assign_attributes(test_code: [''], hints: [''])
  end

  def create
    @result = check_language_and_run(params[:card][:answer], params[:card][:test_code])
    if @result.nil? || @result == "Times out!"
      @card.assign_attributes(card_params)
      error_message
    else
      attr_params = card_params.merge(result: save_type(@result))
      @card.assign_attributes(attr_params)
    end

    if params[:commit] == "送出" && @card.save # 會無法分辨 undefined 訊息
      redirect_to board_card_path(board_id: @board.id, id: @card.id), notice: 'create successfully!'
    else
      render :new
    end
  end

  def edit; end

  def update
    @result = check_language_and_run(params[:card][:answer], params[:card][:test_code])
    if @result.nil? || @result == "Times out!"
      @card.assign_attributes(card_params)
      error_message
      # flash[:alert] = "answer/test_code can't be blank"
      # return render :edit
    # elsif @result == "Times out!"
    #   @card.assign_attributes(card_params)
      # flash[:alert] = 'runtimes out!'
      # return render :edit
    # elsif @result.class == String
    #   @result = [@result]
    #   attr_params = card_params.merge(result: @result)
    #   @card.assign_attributes(attr_params)
    else
      attr_params = card_params.merge(result: save_type(@result))
      @card.assign_attributes(attr_params)
    end

    if params[:commit] == "送出" && @card.update(attr_params)
      redirect_to board_card_path(board_id: @board.id, id: @card.id), notice: 'update successfully!'
    else
      render :edit
    end
  end

  def destroy
    if @card.destroy
      @board.cards.order(:updated_at).each_with_index do |card, idx|
        cur_order = idx + 1
        card.update(order: cur_order) if card.order != cur_order 
      end
      redirect_to board_path(@board), notice: 'deleted!'
    else
      redirect_to board_path(@board)
    end
  end

  def show
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
    service = DockerExec::RubyService.new(params[:record][:code], @card.test_code)
    @result = service.run
    error_message if @result.nil? || @result == "Times out!"
      # error_message
    # elsif @result.class == String
    #   @result = [@result]
    # else
    # end

    @record = @card.records.find_by(user_id: current_user.id)
    if @record.nil?
      @record = current_user.records.new(card_id: @card.id, code: @card.default_code)
    end
    @record.assign_attributes(record_params)

    if params[:commit] == "送出"
      @record.solved = @result == compare_type(@card.result)
      @record.save

      if @record.solved
        flash[:notice] = "You Did it!"
        render 'card_solved'
      else
        flash[:alert] = "wrong!"
        render 'card_solving'
      end
    else
      render 'card_solving'
    end 
  end

  private
  def error_message
    case @result 
    when nil
      flash[:alert] = "Answer / Test_code can't be blank"
    when "Times out!"
      flash[:alert] = "Runtimes Out!"
    end
  end

  def check_language_and_run(code, test_code)
    service = case @board.language
              when "Ruby"
                DockerExec::RubyService.new(code, test_code)
              when "JavaScript"
                DockerExec::JsService.new(code, test_code)
              end
    service.run
  end 

  def check_authority
    redirect_to board_path(id: @board.id), alert: 'check authority error! not owner!' if @board.user_id != current_user.id
  end

  def render_new_solving
    @record = Record.new(card_id: @card.id, code: @card.default_code)
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
