class CardsController < ApplicationController
  def new
    @card = Card.new
  end

  def create
    random_file = [*"a".."z", *"A".."Z"].sample(5).join('') + ".rb"
    tmp_file_path = Rails.root.join('tmp', "#{random_file}").to_s
    test_data = 
      params[:card][:answer].split(",\r\n").map{ |e|
      e = "p " + e
    }.join("\n")
    file = File.open(tmp_file_path, "w")
    file.write(params[:card][:default_code])
    file.write("\n")
    file.write(test_data)
    file.close
    puts "-----"
    puts `docker run -v #{tmp_file_path}:/#{random_file} ruby ruby /#{random_file}`.split("\n")
    puts "-----"


    debugger
    @card = Board.find(params[:board_id]).cards.build(
      card_params.merge(
        level: `docker run -v #{tmp_file_path}:/#{random_file} ruby ruby /#{random_file}`.split("\n")
      )
    )
    debugger
    if @card.save
      redirect_to board_path(params[:board_id]), notice: 'create successfully!'
    else
      render :new
    end
  end

  def edit
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
  end

  def update
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
    @card.update(card_params)
    if @card.save
      redirect_to board_path(params[:board_id]), notice: 'update successfully!'
    else
      render :new
    end
  end



  private

  def card_params
    params.require(:card).permit(:title,
                                 :description,
                                 :default_code,
                                 :answer,
                                 :level,
                                 :tags,
                                 :order,
                                 :board_id)
  end

end
