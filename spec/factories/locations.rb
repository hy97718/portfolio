FactoryBot.define do
  factory :location do
    asset_name { "テスト用資産" }
    location_name { "現金" }
    max_expense { 1000 }
    association :user
  end
end
