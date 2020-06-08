class Card < ApplicationRecord
  # acts_as_paranoid

  belongs_to :board
  has_many :records
  has_many :user, through: :records

  validates :title, presence: true
  validates :level, presence: true
  validates :result, presence: true

  def self.search_by(search_term)
    if search_term
      where("LOWER(title) LIKE :search_term",
      search_term: "%#{search_term.downcase}%")
    else
      all
    end
  end

end
