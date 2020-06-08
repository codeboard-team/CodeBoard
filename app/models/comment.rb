class Comment < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  validates :content, presence: true, length: { minimum: 2 }

  default_scope { where(deleted_at: nil).order(id: :desc) }
end
