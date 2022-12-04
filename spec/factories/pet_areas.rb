FactoryBot.define do
  factory :pet_area do
    association :pet
    association :area
  end
end