FactoryBot.define do
  factory :pet do
    category { :dog }
    petname  { Faker::Name.name }
    introduction { "おとなしく、賢い" }
    gender { :male }
    age { 1 }
    classification { :Chihuahua }
    castration { :neutered }
    vaccination { :vaccinated }
    recruitment_status { 0 }
    association :user

    after(:build) do |pet|
      pet.pet_images << build(:pet_image, pet: pet)
    end
  end
end


