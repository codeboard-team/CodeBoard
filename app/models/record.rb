class Record < ApplicationRecord
  belongs_to :card
  belongs_to :user
  has_many :comments, :as => :commentable

  
  scope :with_solved, -> { where(solved: true) }
end
