FactoryBot.define do
  factory :favorite do
    association :user
    association :pet
  end
end
