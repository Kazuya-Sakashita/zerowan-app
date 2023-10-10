FactoryBot.define do
  factory :admin do
    password = Faker::Internet.password(min_length: 8)
    sequence(:email) { |n| "admin+#{n}@gmail.com" }
    password { password }
    password_confirmation { password }
  end
end
