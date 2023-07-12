FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "テストユーザー#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
  end

  factory :another_user, class: User do
    sequence(:username) { |n| "別のユーザー#{n}" }
    sequence(:email) { |n| "another#{n}@example.com" }
    password { "password" }
  end

  factory :guest_user, class: User do
    sequence(:username) { "ゲストユーザー" }
    sequence(:email) { "guest@example.com" }
    password { "password" }
  end
end
