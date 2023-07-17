FactoryBot.define do
  factory :location do
    sequence(:asset_name) { |n| "テスト資産#{n}" }
    location_name { "銀行口座" }
    max_expense { 1000 }
    association :user
  end
end
