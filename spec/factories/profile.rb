FactoryBot.define do
  factory :profile do
    name { "お名前" }
    address { "ご住所" }
    phone_number { "お電話番号" }
    birthday { "誕生日" }
    breeding_experience { "飼育経験" }
    user
  end
end
