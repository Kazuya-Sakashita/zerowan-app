require 'rails_helper'

RSpec.describe PetImage, type: :model do
  it 'photo 値がない場合にバリデーションエラーが発生すること' do
    pet_image = build(:pet_image, photo: nil)
    pet_image.valid?
    expect(pet_image.errors[:photo]).to include('を入力してください')
  end

  it 'pet_id 値がない場合にバリデーションエラーが発生すること' do
    pet_image = build(:pet_image, pet_id: nil)
    pet_image.valid?
    expect(pet_image.errors[:pet_id]).to include('を入力してください')
  end
  # TODO 画像４枚までのバリデーションができていない
end
