class CardsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  before_action :find_board
  before_action :find_card, only: [:edit, :show, :update, :destroy]
  before_action :build_card, only: %i[new create]

  before_action :check_authority, only: [:new, :edit, :update, :destroy]

  def show; end
  
  def new
    @card.assign_attributes(test_code: [''], hints: [''])
    # @card = @board.cards.new(test_code: [''], hints: [''])
    # @card = Card.new(card_params)
  end

  def create
    result = docker_detached(params[:card][:answer], params[:card][:test_code])
    @card.valid?
    @result = JSON.parse(result)
    if result.nil? || result == "Times out!"
      @card.assign_attributes(card_params)
      flash[:alert] = 'Wrong!'
      return render :new
    else
      attr_params = card_params.merge(result: result)
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
    # @card.assign_attributes(test_code: @card.test_code.join)
    byebug
    result = docker_detached(params[:card][:answer], params[:card][:test_code])
    @result = JSON.parse(result)
    @card.valid?
    # @result = JSON.parse(result)
    if result.nil? || result == "Times out!"
      @card.assign_attributes(card_params)
      flash[:alert] = 'Wrong!'
      return render :edit
    else
      attr_params = card_params.merge(result: result)
      @card.assign_attributes(attr_params)
    end

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
                                 :order,
                                 :board_id,
                                {:tags=>[]},
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
