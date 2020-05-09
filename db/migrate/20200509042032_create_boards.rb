class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.string :title
      t.text :description
      t.string :language
      t.datetime :deleted_at
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :boards, :deleted_at
  end
end
