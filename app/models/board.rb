class Board < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :language, presence: true

  def destroy
    update(deleted_at: Time.now)
  end

end
