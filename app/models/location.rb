class Location < ApplicationRecord
  belongs_to :user
  has_many :incomes
  has_many :expenses
  has_many :fixed_costs

  validates :asset_name, presence: true
  validates :location_name, presence: true

  def balance_money
    income_total = incomes.sum(:income_money)
    expense_total = expenses.sum(:expense_money)
    income_total - expense_total
  end

  def monthly_expense_total(month)
    year, month_num = month.split("-").map(&:to_i)

    # expensesテーブルからデータを取得
    expense_records = expenses.where(expense_day: (Date.new(year, month_num, 1)..Date.new(year, month_num, -1)))

    # 取得したレコードのexpense_moneyを合計
    total_expense = expense_records.sum(:expense_money)

    total_expense
  end

  def check_max_expense(expense)
    year = expense.expense_day.year
    month = expense.expense_day.month.to_s.rjust(2, "0")
    month_str = "#{year}-#{month}"

    expense_total = monthly_expense_total(month_str)

    if max_expense.present? && expense_total >= max_expense
      "上限金額を超えてしまいました。ここから挽回しましょう!"
    elsif max_expense.present? && expense_total >= max_expense * 0.8
      "上限金額の8割になりました。気を引き締めましょう!"
    elsif max_expense.present? && expense_total >= max_expense * 0.5
      "設定した上限金額の半分を超えました。使いすぎに気をつけましょう！！"
    else
      "#{location_name}の出金が登録されました。"
    end
  end
end
