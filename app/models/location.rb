class Location < ApplicationRecord
  belongs_to :user
  has_many :incomes
  has_many :expenses

  validates :asset_name, presence: true
  validates :location_name, presence: true

  def balance_money
    income_total = incomes.sum(:income_money)
    expense_total = expenses.sum(:expense_money)
    income_total - expense_total
  end
end
