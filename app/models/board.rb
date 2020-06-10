class Board < ApplicationRecord
  acts_as_paranoid

  has_many :cards
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :language, presence: true

  before_update :prevent_language_changed!
  before_destroy :check_before_modify!

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

  def has_records?
    self.cards.map { |card| card.records.exists? }.include?(true)
  end

  private
  def check_before_modify!
    if has_records?
      errors.add :base, "很抱歉！已有答題紀錄，無法進行題組修改"
      throw(:abort)
    else
      self.cards.each do |card|
        card.destroy
      end
    end
  end

  def prevent_language_changed!
    if has_records? && change_language?
      errors.add :base, "很抱歉！已有答題紀錄，無法更改題組的程式語言"
      throw(:abort)
    end
  end

  def change_language?
    self.changed_attributes.include?(:language)
  end

end
