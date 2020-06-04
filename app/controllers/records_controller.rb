class RecordsController < ApplicationController
  before_action :find_record, :find_board, :find_card

  def show
  end

  private
  def find_record
    @record = Record.find(params[:id])
  end

  def find_board
    @board = @record.card.board
  end

  def find_card
    @card = @record.card
    @solved_cards = @card.records.with_solved
  end

end
