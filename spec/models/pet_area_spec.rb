require 'rails_helper'

RSpec.describe PetArea, type: :model do
  describe 'バリデーション' do
    let(:pet) { create(:pet) }
    let(:area) { create(:area) }

    it '有効な属性があれば有効であること' do
      pet_area = PetArea.new(pet:, area:)

      expect(pet_area).to be_valid
    end

    it 'petが存在しない場合は無効であること' do
      pet_area = PetArea.new(area:)

      expect(pet_area).not_to be_valid
      pet_area.valid?
      expect(pet_area.errors[:pet]).to include('を入力してください')
    end

    it 'areaが存在しない場合は無効であること' do
      pet_area = PetArea.new(pet:)

      expect(pet_area).not_to be_valid
      pet_area.valid?
      expect(pet_area.errors[:area]).to include('を入力してください')
    end
  end
end
