class Board < ApplicationRecord
  has_many :cards
  belongs_to :user

  validates :title, presence: true
  validates :language, presence: true

  default_scope -> { where(deleted_at: nil)}

  def destroy
    update(deleted_at: Time.now)
  end

end