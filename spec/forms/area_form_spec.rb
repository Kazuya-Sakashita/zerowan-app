require 'rails_helper'
include PetAreasValidSupport

RSpec.describe AreaForm, type: :model do

  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user_id: user.id) }

  context '1箇所以上、47箇所まで譲渡範囲バリデーション' do

    context '正常系' do
      it '譲渡範囲が1箇所であれば有効であること' do
        available_area = 1
        transfer_areas(available_area)
        expect(@pet_areas).to be_valid
      end

      it '譲渡範囲が47箇所であれば有効であること' do
        available_area= 47
        transfer_areas(available_area)
        expect(@pet_areas).to be_valid
      end
    end

    context '異常系' do
      it '譲渡範囲が0箇所であれば無効であること' do
        available_area = 0
        transfer_areas(available_area)
        expect(@pet_areas).not_to be_valid
        expect(@pet_areas.errors.full_messages).to include('譲渡範囲入力を確認してください。')
      end

      it '譲渡範囲が48箇所であれば無効であること' do
        available_area= 48
        transfer_areas(available_area)
        expect(@pet_areas).not_to be_valid
        expect(@pet_areas.errors.full_messages).to include('譲渡範囲入力を確認してください。')
      end
    end
  end
end