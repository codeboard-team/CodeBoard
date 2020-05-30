class Card < ApplicationRecord
  TAGS = %w[ALGORITHMS ARRAYS BIONARY STRINGS SYMBOL HASH OBJECT NUMBERS RULES LOOPS UTILITIES MATHEMATICS LISTS DATA_STRCTURES ...].freeze

  belongs_to :board
  has_many :records
  has_many :user, through: :records

  validates :title, presence: true
  validates :level, presence: true
  validates :result, presence: true
  # custom validators: 用單數
  # validate :tags_validation  

  default_scope -> { where(deleted_at: nil)}

  def destroy
    update(deleted_at: Time.now)
  end
end
