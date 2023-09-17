require 'rails_helper'

RSpec.describe Favorite, type: :model do
  # お気に入り設定するユーザー登録
  let(:customer) do
    create(:user, email: 'test123456789@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
  end

  let(:pet) do
    create(:pet)
  end

  describe 'バリデーション' do
    before do
      create(:favorite, user_id: customer.id, pet_id: pet.id)
    end

    it 'すでにお気に入りしている場合は、お気に入り登録されないこと' do
      duplicate_favorite = Favorite.new(user: customer, pet: pet)

      expect(duplicate_favorite.valid?).to be_falsey
      expect(duplicate_favorite.errors[:pet_id]).to include("お気に入りはすでに設定されています。")
    end

  end
end