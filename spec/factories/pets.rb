FactoryBot.define do
  factory :pet do
    category { 1 }
    name { "MyString" }
    introduction { "MyText" }
    gender { 1 }
    age { 1 }
    classification { 1 }
    castration { 1 }
    vaccination { 1 }
    recruitment_status { 1 }
    user_id { 1 }
  end
end
