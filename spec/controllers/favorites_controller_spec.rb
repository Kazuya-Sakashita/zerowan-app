require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  describe 'お気に入り機能' do
    let(:headers){ { 'HTTP_REFERER' => referer } }
    let!(:referer){ "/" }

    let(:customer) do
      create(:user, email: 'test123456789@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
    end

    let(:pet) do
      create(:pet)
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in customer
      request.headers.merge! headers
    end

    it '正しく設定された場合、登録されていること' do
      expect { post :create, params: {user_id: customer.id, pet_id: pet.id} }.to change(Favorite, :count).by(1)
    end

    it '正しく設定された場合、解除されていること' do
      create(:favorite, user_id: customer.id, pet_id: pet.id )
      expect { delete :destroy, params: {user_id: customer.id, pet_id: pet.id} }.to change(Favorite, :count).by(-1)
    end
  end
end