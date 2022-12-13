# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 都道府県初期データ入力
# Area.create(place_name: '北海道')
# Area.create(place_name: '青森')
# Area.create(place_name: '秋田')
# Area.create(place_name: '岩手')
# Area.create(place_name: '宮城')
# Area.create(place_name: '山形')
# Area.create(place_name: '福島')
# Area.create(place_name: '栃木')
# Area.create(place_name: '茨城')
# Area.create(place_name: '群馬')
# Area.create(place_name: '埼玉')
# Area.create(place_name: '千葉')
# Area.create(place_name: '東京')
# Area.create(place_name: '神奈川')
# Area.create(place_name: '新潟')
# Area.create(place_name: '富山')
# Area.create(place_name: '石川')
# Area.create(place_name: '福井')
# Area.create(place_name: '山梨')
# Area.create(place_name: '長野')
# Area.create(place_name: '岐阜')
# Area.create(place_name: '静岡')
# Area.create(place_name: '愛知')
# Area.create(place_name: '三重')
# Area.create(place_name: '滋賀')
# Area.create(place_name: '京都')
# Area.create(place_name: '大阪')
# Area.create(place_name: '兵庫')
# Area.create(place_name: '奈良')
# Area.create(place_name: '和歌山')
# Area.create(place_name: '鳥取')
# Area.create(place_name: '島根')
# Area.create(place_name: '岡山')
# Area.create(place_name: '広島')
# Area.create(place_name: '山口')
# Area.create(place_name: '徳島')
# Area.create(place_name: '香川')
# Area.create(place_name: '愛媛')
# Area.create(place_name: '高知')
# Area.create(place_name: '福岡')
# Area.create(place_name: '佐賀')
# Area.create(place_name: '長崎')
# Area.create(place_name: '熊本')
# Area.create(place_name: '大分')
# Area.create(place_name: '宮崎')
# Area.create(place_name: '鹿児島')
# Area.create(place_name: '沖縄')

# テストユーザー登録
# 5.times do |n|
#   User.create(email: "test#{n + 1}@test.com",
#               password: 'password',
#               password_confirmation: 'password',
#               confirmed_at: DateTime.now,
#               profile_attributes: {
#                 name: "テストユーザー#{n + 1}",
#                 address: '大阪市天王寺',
#                 phone_number: '0' * 11,
#                 birthday: '2010-02-11',
#                 breeding_experience: '犬1年' })
# end

# User.create(email: "test_toukou@test.com",
#             password: 'password',
#             password_confirmation: 'password',
#             confirmed_at: DateTime.now,
#             profile_attributes: {
#               name: "テスト投稿ユーザー",
#               address: '大阪市天王寺',
#               phone_number: '0' * 11,
#               birthday: '2010-02-11',
#               breeding_experience: '犬1年' })
#
# 50.times do |n|
#   Pet.create(category: :dog,
#              petname: "ワンコネーム#{n + 1}",
#              age: 1,
#              gender: :male,
#              classification: :Chihuahua,
#              introduction: 'おとなしく、賢い',
#              castration: :neutered,
#              vaccination: :vaccinated,
#              recruitment_status: 0,
#              user_id: User.last.id)
#   PetImage.create(
#     photo: File.open("./app/assets/images/dog_default.jpeg"),
#     pet_id: Pet.last.id
#   )
#   PetArea.create(
#     area_id: 27,
#     pet_id: Pet.last.id
#   )
# end