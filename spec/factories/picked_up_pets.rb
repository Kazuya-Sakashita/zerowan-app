FactoryBot.define do
  factory :picked_up_pet do
    association :pet
    picked_up_at { Time.current }
  end
end
