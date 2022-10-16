require 'rails_helper'

RSpec.describe PetForm, type: :model do

  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user_id: user.id) }

  context '１枚以上、４枚まで画像バリデーション' do
    context '正常系' do
      it '画像枚数が1枚であれば有効であること' do
        photos = []
        1.times do
          photos << pet_image = build(:pet_image, pet_id: pet.id)
        end

        @pet_imagaes = PetForm.new
        @pet_imagaes.photos = photos
        @pet_imagaes.valid?
        expect(@pet_imagaes).to be_valid
      end

      it '画像枚数が4枚であれば有効であること' do
        photos = []
        4.times do
          photos << pet_image = build(:pet_image, pet_id: pet.id)
        end

        @pet_imagaes = PetForm.new
        @pet_imagaes.photos = photos
        @pet_imagaes.valid?
        expect(@pet_imagaes).to be_valid
      end
    end

    context '異常系' do
      it '画像枚数が0枚であれば無効であること' do
        photos = []

        @pet_imagaes = PetForm.new
        @pet_imagaes.photos = photos
        @pet_imagaes.valid?
        expect(@pet_imagaes.errors.full_messages).to include('紹介画像添付枚数を確認してください。')
      end

      it '画像枚数が5枚であれば無効であること' do
        photos = []
        5.times do
          photos << pet_image = build(:pet_image, pet_id: pet.id)
        end

        @pet_imagaes = PetForm.new
        @pet_imagaes.photos = photos
        @pet_imagaes.valid?
        expect(@pet_imagaes.errors.full_messages).to include('紹介画像添付枚数を確認してください。')
      end
    end
  end
end