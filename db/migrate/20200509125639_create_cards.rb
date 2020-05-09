class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.string :title
      t.text :description
      t.text :default_code
      t.text :answer
      t.string :level
      t.string :tags, array: true
      t.integer :order
      t.datetime :deleted_at
      t.belongs_to :board, null: false, foreign_key: true

      t.timestamps
    end
    add_index :cards, :tags
    add_index :cards, :deleted_at
  end
end
