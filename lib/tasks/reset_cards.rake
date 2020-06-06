namespace :db do
  desc "Reset cards which board has deleted"
  task reset_cards: :environment do
    puts 'prepare to reset cards'
    Board.only_deleted.each do |board|
      board.cards.each do |card|
        card.destroy
      end
    end
    puts 'finished!'
  end

end
