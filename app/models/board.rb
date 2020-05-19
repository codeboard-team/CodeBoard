class Board < ApplicationRecord
  has_many :cards
  belongs_to :user

  validates :title, presence: true
  validates :language, presence: true

  default_scope -> { where(deleted_at: nil)}

  def destroy
    update(deleted_at: Time.now)
  end

  def self.search_by(search_term)
    if search_term
      where("LOWER(title) LIKE :search_term",
      search_term: "%#{search_term.downcase}%")
    else
      all
    end
  end
end
