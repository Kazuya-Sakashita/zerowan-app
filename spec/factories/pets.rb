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
  end
end
