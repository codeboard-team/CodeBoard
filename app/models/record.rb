class Record < ApplicationRecord
  belongs_to :Card
  belongs_to :User
  
  validate: code, presence: true
end
