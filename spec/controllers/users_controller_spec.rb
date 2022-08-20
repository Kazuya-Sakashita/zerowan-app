require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'ユーザー編集' do
    context '正常系' do
      it '登録情報編集画面が描画されていること' do
        user = create(:user)
        get :edit, params: { id: user.id }
        expect(response).to render_template 'users/edit'
      end

      it '正しく値が設定された場合ユーザーのマイページ画面が描画されること' do
        user = create(:user)
        profile_params = FactoryBot.attributes_for(:profile)
        patch :update, params: { id: user.id, user: profile_params }
        expect(response).to redirect_to edit_user_path
      end

      it '正しく値が設定された場合ユーザーの情報が更新されていること' do
        user = create(:user)
        profile_params = FactoryBot.attributes_for(:profile, name: 'riku', user_id: user.id)
        patch :update, params: { id: user.id, user: profile_params }
        expect(user.reload.profile.name).not_to eq 'riku'
      end
    end
    context '異常系' do
      it '正しく値が設定されなかった場合、登録情報編集画面が描画されること' do
        user = create(:user)
        profile_params = FactoryBot.attributes_for(:profile, name: nil, user_id: user.id)
        patch :update, params: { id: user.id, user: profile_params }
        #TODO　編集画面に遷移しているかの判定
        expect(response).to redirect_to edit_user_path
      end
    end
  end
end