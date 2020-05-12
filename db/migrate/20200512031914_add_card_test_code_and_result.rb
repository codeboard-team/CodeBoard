class AddCardTestCodeAndResult < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :test_code, :text, array: true
    add_index :cards, :test_code
    add_column :cards, :result, :text, array: true
    add_index :cards, :result
  end
end
