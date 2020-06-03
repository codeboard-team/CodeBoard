class Record < ApplicationRecord
  belongs_to :card
  belongs_to :user
  
  # validates :code, presence: true
  
   # Rcord.with_sloved
  scope :with_solved, -> { where(solved: true) }
end
