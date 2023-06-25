class Income < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :income_name, presence: true, length: { maximum: 20 }
  validates :income_day, presence: true
  validates :income_money, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :income_memo,  length: { maximum: 50 }

  def self.search(keyword)
    where("income_name LIKE ? OR income_memo LIKE ?", "%#{keyword}%", "%#{keyword}%")
  end
end
