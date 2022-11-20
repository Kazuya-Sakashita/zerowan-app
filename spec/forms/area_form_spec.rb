require 'rails_helper'

RSpec.describe AreaForm, type: :model do
  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user_id: user.id) }

  context '1箇所以上、47箇所まで譲渡範囲バリデーション' do
    let(:areas_1) { build_list(:pet_area, 1, pet_id: pet.id) }
    let(:areas_47) { build_list(:pet_area, 47, pet_id: pet.id) }
    let(:areas_0) { build_list(:pet_area, 0, pet_id: pet.id) }
    let(:areas_48) { build_list(:pet_area, 48, pet_id: pet.id) }

    before do
      @pet_areas = AreaForm.new
      @pet_areas.areas = available_num
      @pet_areas.valid?
    end
    context '譲渡範囲1箇所' do
      let(:available_num) { areas_1 }
      it '有効であること' do
        expect(@pet_areas).to be_valid
      end
    end
    context '譲渡範囲47箇所' do
      let(:available_num) { areas_47 }
      it '有効であること' do
        expect(@pet_areas).to be_valid
      end
    end

    context '譲渡範囲0箇所' do
      let(:available_num) { areas_0 }
      it '無効であること' do
        expect(@pet_areas).not_to be_valid
        expect(@pet_areas.errors.full_messages).to include('譲渡範囲入力を確認してください。')
      end
    end

    context '譲渡範囲48箇所' do
      let(:available_num) { areas_48 }
      it '無効であること' do
        expect(@pet_areas).not_to be_valid
        expect(@pet_areas.errors.full_messages).to include('譲渡範囲入力を確認してください。')
      end
    end
  end
end
