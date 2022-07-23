FactoryBot.define do
  factory :profile do
    name  { Faker::Name.name }
    address { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.subscriber_number(length: 11) }
    birthday { Faker::Date.between(from: '1930-01-01', to: '2016-12-31') }
    breeding_experience { '犬2年' }
    user_id {''}
  end
end
