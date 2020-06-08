class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :deleted_at
      t.belongs_to :commentable, :polymorphic => true


      t.timestamps
    end
    add_index :comments, :deleted_at
  end
end
