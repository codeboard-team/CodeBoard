class Card < ApplicationRecord
  TAGS = %w[Algorithms Arrays Bionary Data_Structures Strings Symbol Hash Object Numbers Rules Loops Utilities Mathematics Methods While If...else Lists Each].freeze

  belongs_to :board
  has_many :records
  has_many :user, through: :records
  validates :title, presence: true
  validates :level, presence: true
  validates :result, presence: true

  before_update :check_before_modify!
  before_destroy :check_before_modify!

  def self.search_by(search_term)
    if search_term
      where("LOWER(title) LIKE :search_term",
      search_term: "%#{search_term.downcase}%")
    else
      all
    end
  end

  def has_records?
    self.records.exists?
  end

  private
  def check_before_modify!
    if has_records?
      errors.add :base, "很抱歉！已有答題紀錄，您無法進行題目修改"
      throw(:abort)
    end
  end

end
