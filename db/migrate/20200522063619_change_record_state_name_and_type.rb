class ChangeRecordStateNameAndType < ActiveRecord::Migration[6.0]
  def change
    add_column :records, :solved, :boolean
    remove_column :records, :state
  end
end
