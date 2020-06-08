class Board < ApplicationRecord
  # acts_as_paranoid

  has_many :cards, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :language, presence: true

  def self.search_by_title(search_term)
    if search_term
      where("LOWER(boards.title) LIKE :search_term",
      search_term: "%#{search_term.downcase}%")
    else
      all
    end
  end

  def editor_mode
    case self.language
      when "Ruby"
        "ace/mode/ruby"
      when "Python"
        "ace/mode/python"
      when "JavaScript"
        "ace/mode/javascript"
    end
  end
end
