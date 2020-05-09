class Board < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :language, presence: true

end
