FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(min_length: 8)
    sequence(:email) { |n| "test#{n}@example.com" }
    password { password }
  end
end
