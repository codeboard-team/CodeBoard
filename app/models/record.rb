class Record < ApplicationRecord
  belongs_to :card
  belongs_to :user
  
  validates :code, presence: true
end
