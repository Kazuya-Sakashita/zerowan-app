require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'DM Room作成' do
    let!(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @pet = create(:pet)
      sign_in user
    end

    context 'petへの問い合わせが初めての場合' do
      it 'ルームテーブルに登録されていること' do
        expect do
          get :show, params: { pet_id: @pet.id }
        end.to change { Room.count }.by(1)
      end
    end

    context 'petへの問い合わせが2回目以降の場合' do
      before do
        get :show, params: { pet_id: @pet.id }
      end

      it 'ルームテーブルに登録されていないこと' do
        expect do
          get :show, params: { pet_id: @pet.id }
        end.to change { Room.count }.by(0)
      end
    end

    context 'ペットの飼い主と閲覧ユーザー' do
      before do
        @pet_cust = create(:pet, user_id: user.id)
      end

      it '正しく設定された場合は、rooms/showに遷移すること' do
        get :show, params: { pet_id: @pet.id }
        expect(response).to render_template 'rooms/show'
      end

      it '正しく設定されなかった場合は、pet/showのままであること' do
        get :show, params: { pet_id: @pet_cust.id }
        expect(response).to redirect_to pet_path(@pet_cust)
      end
    end
  end
end