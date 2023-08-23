FactoryBot.define do
  factory :expense do
    sequence(:expense_name) { |n| "expense #{n}" }
    expense_day { Date.today }
    expense_money { 1000 }
    expense_memo { "expense memo" }
    association :user
    association :location
  end
end
