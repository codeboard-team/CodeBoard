class CardsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :check_authority, only: [:new, :edit, :update, :destroy]

  def show
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
  end
  
  def new
    @card = Card.new(test_code: [''], hints: [''])
  end

  def create
    result = docker_detached(params[:card][:answer], params[:card][:test_code])
    # @card.valid?
    # @result = JSON.parse(result)
    if result == nil || result == "Times out!"
      @card = Board.find(params[:board_id]).cards.build(card_params)
      return 1
    else
      @card = Board.find(params[:board_id]).cards.build(
        card_params.merge(
          result: result
        )
      )
    end

    if @card.save
      redirect_to board_card_path(board_id: params[:board_id], id: @card.id), notice: 'create successfully!'
    else
      redirect_to new_board_card_path(board_id: params[:board_id])
    end
  end

  def edit
    @card = Board.find(params[:board_id]).cards.find(params[:id])
  end

  def update
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
    @card.update(card_params)
    if @card.save
      redirect_to board_card_path(board_id: params[:board_id], id: @card.id), notice: 'update successfully!'
    else
      render :edit
    end
  end

  def destroy
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
    @card.destroy
    redirect_to board_path(params[:board_id]), notice: 'deleted!'
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
    redirect_to board_path(id: params[:board_id]) if Board.find(params[:board_id]).user_id != current_user.id
  end

  def set_card
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
                                 :hints=>[],
                                 :test_code=>[])
  end

end
