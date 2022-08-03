FactoryBot.define do
  factory :pet do
    category { 1 }
    image { "MyString" }
    name { "MyString" }
    introduction { "MyText" }
    gender { 1 }
    castration { false }
    vaccination { false }
    recruitment_status { 1 }
     user_id { 1 }
  end
end
