class CardsController < ApplicationController
  def new
    @card = Card.new
  end

  def create
    # random_file = [*"a".."z", *"A".."Z"].sample(5).join('') + ".rb"
    # tmp_file_path = Rails.root.join('tmp', "#{random_file}").to_s
    # test_data = params[:card][:test_code].split(",\r\n").map{ |e| e = "p " + e }.join("\n")
    # file = File.open(tmp_file_path, "w")
    # file.write(params[:card][:answer])
    # file.write("\n")
    # file.write(test_data)
    # file.close
    # result = `docker run -v #{tmp_file_path}:/#{random_file} ruby ruby /#{random_file}`
    # File.unlink(tmp_file_path)
    puts '------------------------'
    puts "#{params[:card][:test_code]}"
    puts '------------------------'
    docker_run(params[:card][:answer], params[:card][:test_code])
    puts '------------------------'
    puts "#{params[:card][:test_code]}"
    puts '------------------------'
    @card = Board.find(params[:board_id]).cards.build(
      card_params.merge(
        test_code: params[:card][:test_code],
        result: @result.split("\n")
      )
    )
    if @card.save
      render :new
      # redirect_to board_path(params[:board_id]), notice: 'create successfully!'
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

  def destroy
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
    @card.destroy
    redirect_to board_path(params[:board_id]), notice: 'deleted!'
  end

  def show
  end

  private
  def docker_run(code, test_code)
    random_file = [*"a".."z", *"A".."Z"].sample(5).join('') + ".rb"
    tmp_file_path = Rails.root.join('tmp', "#{random_file}").to_s
    test_data = test_code.split(",\r\n").map{ |e| e = "p " + e }.join(";\n")
    file = File.open(tmp_file_path, "w")
    file.write(code)
    file.write("\n")
    file.write(test_data)
    file.close
    @result = `docker run -v #{tmp_file_path}:/#{random_file} ruby ruby /#{random_file}`
    # File.unlink(tmp_file_path)
    return @result
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
                                 :test_code)
  end

end
