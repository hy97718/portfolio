class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :expense_name, presence: true, length: { maximum: 20 }
  validates :expense_day, presence: true
  validates :expense_money, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :expense_memo,  length: { maximum: 50 }

  def self.search(keyword)
    where("expense_name LIKE ? OR expense_memo LIKE ?", "%#{keyword}%", "%#{keyword}%")
  end
end
