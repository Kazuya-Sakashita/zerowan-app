require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'ユーザー編集' do
    before do
      @user = create(:user)
    end
    context '正常系' do
      it '登録情報編集画面が描画されていること' do
        get :edit, params: { id: @user.id }
        expect(response).to render_template 'users/edit'
      end

      it '正しく値が設定された場合ユーザーのマイページ画面が描画されること' do
        profile_params = FactoryBot.attributes_for(:profile)
        patch :update, params: { id: @user, user: { profile_attributes: profile_params } }
        expect(response).to redirect_to user_path
      end

      it '正しく値が設定された場合ユーザーの情報が更新されていること' do
        profile_params = FactoryBot.attributes_for(:profile, name: 'riku', user_id: @user.id)
        patch :update, params: { id: @user, user: { profile_attributes: profile_params } }
        expect(@user.reload.profile.name).to eq 'riku'
      end
    end
    context '異常系' do
      it '正しく値が設定されなかった場合、登録情報編集画面が描画されること' do
        profile_params = FactoryBot.attributes_for(:profile, name: nil, user_id: @user.id)
        patch :update, params: { id: @user, user: { profile_attributes: profile_params } }
        expect(response).to redirect_to action: :edit
      end
    end
  end
end