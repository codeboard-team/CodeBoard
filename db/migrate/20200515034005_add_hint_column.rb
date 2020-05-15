class AddHintColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :hints, :text, array: true
    add_index :cards, :hints
  end
end
