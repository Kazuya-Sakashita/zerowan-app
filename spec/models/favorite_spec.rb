require 'rails_helper'

RSpec.describe Favorite, type: :model do
  # お気に入り設定するユーザー登録
  let(:user) do
    create(:user, email: 'test123456789@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
  end

  # ユーザー登録、ペット登録
  before do
    create(:user, email: 'pettoukou@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
    create(:area, place_name: '大阪')
    create(:pet,
           category: :dog,
           petname: 'taro20221101',
           age: 12,
           gender: :male,
           classification: :Chihuahua,
           introduction: 'おとなしく、賢い',
           castration: :neutered,
           vaccination: :vaccinated,
           recruitment_status: 0,
           user: User.last)
    create(:pet_area, pet_id: Pet.last.id, area_id:Area.last.id)
  end


  describe 'バリデーション' do
    before do
      create(:favorite, user_id: user.id, pet_id: Pet.last.id)
    end
    it 'すでにお気に入りしている場合は、お気に入り登録されないこと' do
      expect { create(:favorite, user_id: user.id, pet_id: Pet.last.id) }.to raise_error('レコード無効')
    end

  end
end