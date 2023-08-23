FactoryBot.define do
  factory :income do
    sequence(:income_name) { |n| "Income #{n}" }
    income_day { Date.today }
    income_money { 1000 }
    income_memo { "Income memo" }
    association :user
    association :location
  end
end
