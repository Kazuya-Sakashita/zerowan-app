FactoryBot.define do
  factory :pet_image do
    pet_id { 1 }
    photo { Faker::Avatar.image }
  end
end
