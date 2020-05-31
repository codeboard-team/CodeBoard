class Card < ApplicationRecord

  belongs_to :board
  has_many :records
  has_many :user, through: :records
  has_many :comment
  validates :title, presence: true
  validates :level, presence: true
  validates :result, presence: true
    
  default_scope -> { where(deleted_at: nil)}

  def destroy
    update(deleted_at: Time.now)
  end

end
