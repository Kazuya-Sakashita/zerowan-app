FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(min_length: 8)
    sequence(:email) { |n| "kz.sincerity+#{n}@gmail.com" }
    password { password }
    password_confirmation { password }
    profile { FactoryBot.build :profile }
    confirmed_at { Date.today }
  end
end