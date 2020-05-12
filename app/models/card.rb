class Card < ApplicationRecord
  belongs_to :board
  has_many :records
  validates :title, presence: true
  
  default_scope -> { where(deleted_at: nil)}

  def destroy
    update(deleted_at: Time.now)
  end

end
