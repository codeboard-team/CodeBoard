class CardsController < ApplicationController

  def show
  end

  def new
    @card = Card.new(test_code: [''])
  end

  def create
    random_file = [*"a".."z", *"A".."Z"].sample(5).join('') + ".rb"
    tmp_file_path = Rails.root.join('tmp', "#{random_file}").to_s
    test_data = params[:card][:test_code].split(",\r\n").map{ |e| e = "result.push(#{e})" }.join("\n")
    file = File.open(tmp_file_path, "w")
    contents = [params[:card][:answer],"require 'json'","result = []",test_data,"puts JSON.generate(result)"]
    contents.each { |e|
      file.write(e)
      file.write("\n")
    }
    file.close
    result = `docker run -d -v #{tmp_file_path}:/#{random_file} ruby ruby /#{random_file}`
    # File.unlink(tmp_file_path)
    # @result = docker_run(params[:card][:answer], params[:card][:test_code])
    debugger
    @card = Board.find(params[:board_id]).cards.build(
      card_params.merge(
        test_code: params[:card][:test_code].split(",\r\n"),
        result: @result
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
    @card = Board.find(params[:board_id]).cards.find_by(id: params[:id])
  end

  private
  def docker_detached(code, test_code)
    random_file = [*"a".."z", *"A".."Z"].sample(5).join('') + ".rb"
    tmp_file_path = Rails.root.join('tmp', "#{random_file}").to_s
    test_data = test_code.split(",\r\n").map{ |e| e = "result.push(#{e})" }.join("\n")
    file = File.open(tmp_file_path, "w")
    contents = [code,"require 'json'","result = []",test_data,"puts '======'","puts JSON.generate(result)"]
    contents.each { |e|
      file.write(e)
      file.write("\n")
    }
    file.close
    result = `docker run --rm -v #{tmp_file_path}:/#{random_file} ruby ruby /#{random_file}`
    File.unlink(tmp_file_path)
    return result
  end

  def docker_run(code, test_code)
    random_file = [*"a".."z", *"A".."Z"].sample(5).join('') + ".rb"
    tmp_file_path = Rails.root.join('tmp', "#{random_file}").to_s
    test_data = test_code.split(",\r\n").map{ |e| e = "result.push(#{e})" }.join("\n")
    file = File.open(tmp_file_path, "w")
    contents = [code,"require 'json'","result = []",test_data,"puts '======'","puts JSON.generate(result)"]
    contents.each { |e|
      file.write(e)
      file.write("\n")
    }
    file.close
    result = `docker run --rm -v #{tmp_file_path}:/#{random_file} ruby ruby /#{random_file}`.split('======').pop
    File.unlink(tmp_file_path)
    return result
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
                                 :test_code=>[])
  end

end