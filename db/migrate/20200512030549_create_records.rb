class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.text :code
      t.string :state
      t.integer :user_id
      t.integer :card_id

      t.timestamps
    end
  end
end
