require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  describe 'お気に入り機能' do
    let(:headers){ { 'HTTP_REFERER' => referer } }
    let!(:referer){ "/" }

    # お気に入り設定するユーザー登録
    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
    end
    let(:params) do
      {
        pet_id: Pet.last.id,
        user_id: user.id
      }
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]

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
      create(:pet_area, pet_id: Pet.last.id, area_id: Area.last.id)
      sign_in user
      request.headers.merge! headers
    end

    it '正しく設定された場合、登録されていること' do
      expect { post :create, params: params }.to change(Favorite, :count).by(1)
    end

    it '正しく設定された場合、解除されていること' do
      post :create,  params: params
      expect { delete :destroy, params: params }.to change(Favorite, :count).by(-1)
    end
  end
end