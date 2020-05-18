class CardsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :edit, :update, :destroy]

  before_action :find_board
  before_action :find_card, only: [:edit, :show, :update, :destroy, :solve]
  before_action :build_card, only: %i[new create]

  before_action :check_authority, only: [:new, :edit, :update, :destroy]
  
  def new
    @card.assign_attributes(test_code: [''], hints: [''])
    # @card = @board.cards.new(test_code: [''], hints: [''])
    # @card = Card.new(card_params)
  end

  def create
    result = docker_detached(params[:card][:answer], params[:card][:test_code]).strip
    @card.valid?
    # @result = JSON.parse(result)
    if result.nil? || result == "Times out!"
      @card.assign_attributes(card_params)
      flash[:alert] = 'Wrong!'
      return render :new
    else
      attr_params = card_params.merge(result: JSON.parse(result).map{ |x| x.to_s })
      @card.assign_attributes(attr_params)
    end
    if @card.save
      redirect_to board_card_path(board_id: @board.id, id: @card.id), notice: 'create successfully!'
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    if @card.update(card_params)
      render :edit
      # redirect_to board_card_path(board_id: @board.id, id: @card.id), notice: 'update successfully!'
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
    record = @card.records.find_by(user_id: current_user.id)
    if @board.user == current_user
      render '_card_questioner'
    elsif record && record.state
      render '_card_solved'
    else
      render '_card_solving'
    end
  end

  def solve
    result = JSON.parse(docker_detached(params[:card][:default_code], @card.test_code).strip).map{ |e| e.to_s }
    current_user.records.create(card_id: @card.id) unless @card.records.find_by(user_id: current_user.id)
    record = @card.records.find_by(user_id: current_user.id)
    if result == @card.result
      record.update(code: params[:card][:default_code], state: true)
      flash[:notice] = "You Did it!"
      render '_card_solved'
    else
      record.update(code: params[:card][:default_code])
      flash[:alert] = "Wrong!!"
      render '_card_solving'
    end 
  end


  private
  def docker_detached(code, test_code)
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
    id = `docker run -d -v #{tmp_file_path}:/#{random_file} ruby ruby /#{random_file}`
    5.times do
      if `docker ps --format "{{.ID}}: {{.Status}}" -f "id=#{id}"` == ""
        File.unlink(tmp_file_path)
        result = `docker logs #{id}`.split('======').pop
        `docker rm -f #{id}`
        return result
      else
        sleep 1
      end
    end
    File.unlink(tmp_file_path)
    `docker rm -f #{id}`
    return "Times out!"
  end

  def check_authority
    redirect_to board_path(id: @board.id), notice: 'check authority error! not owner!' if @board.user_id != current_user.id
  end

  def card_params
    params.require(:card).permit(:title,
                                 :description,
                                 :default_code,
                                 :answer,
                                 :level,
                                 :tags,
                                 :order,
                                 :board_id,
                                 :result=>[],
                                 :hints=>[],
                                 :test_code=>[])
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
