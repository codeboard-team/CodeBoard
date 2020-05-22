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
    @result = docker_detached(params[:card][:answer], params[:card][:test_code]) 
    if @result.nil? || @result == "Times out!"
      @card.assign_attributes(card_params)
      flash[:alert] = 'Error!'
      return render :new
    else
      attr_params = card_params.merge(result: save_type(@result))
      @card.assign_attributes(attr_params)
    end

    if params[:commit] == "送出" && @card.save
      redirect_to board_card_path(board_id: @board.id, id: @card.id), notice: 'create successfully!'
    else
      render :new
    end
  end

  def edit; end

  def update
    @result = docker_detached(params[:card][:answer], params[:card][:test_code])
    if @result.nil? || @result == "Times out!"
      @card.assign_attributes(card_params)
      flash[:alert] = 'Error!'
      return render :edit
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
        if @record.present? && @record.state
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
    @result = docker_detached(params[:record][:code], @card.test_code)
    @record = @card.records.find_by(user_id: current_user.id)

    if @record.nil?
      @record = current_user.records.new(card_id: @card.id, code: @card.default_code)
    end
    @record.attributes = record_params

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
  def docker_detached(code, test_code)
    return flash[:alert] = "answer shouldn't be nil" if code.nil? || test_code.nil?
    random_file = [*"a".."z", *"A".."Z"].sample(5).join('') + ".rb"
    tmp_file_path = Rails.root.join('tmp', "#{random_file}").to_s
    test_data = test_code.map{ |e| e = "result.push(#{e})" }.join("\n")
    file = File.open(tmp_file_path, "w")
    contents = [code,"require 'json'","result = []",test_data,"puts '======'","puts JSON.generate(result)"]
    contents.each { |e|
      file.write(e)
      file.write("\n")
    }
    file.close
    id = `docker run -d -v #{tmp_file_path}:/code.rb ruby ruby /code.rb`
    # 每一秒檢查一次是否運算完成，共 5 次
    5.times do
      if `docker ps --format "{{.ID}}: {{.Status}}" -f "id=#{id}"` == ""
        File.unlink(tmp_file_path)
        raw_output = `docker logs #{id}`
        if raw_output == ""
          return nil
        else
          result = JSON.parse(raw_output.split('======').pop.strip)
          `docker rm -f #{id}`
          return result
        end
      else
        sleep 1
      end
    end
    File.unlink(tmp_file_path)
    `docker rm -f #{id} `
    return "Times out!"
  end

  def check_authority
    redirect_to board_path(id: @board.id), notice: 'check authority error! not owner!' if @board.user_id != current_user.id
  end

  def render_new_solving
    @record = Record.new(card_id: @card.id, code: @card.default_code)
    render 'card_solving'
  end

  def save_type(raw=[])
    raw.map{ |e| JSON.generate(e) }
  end

  def compare_type(raw=[])
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
