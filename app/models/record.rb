class Record < ApplicationRecord
  belongs_to :card
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  # validates :code, presence: true
  
  scope :with_solved, -> { where(solved: true) }
end
