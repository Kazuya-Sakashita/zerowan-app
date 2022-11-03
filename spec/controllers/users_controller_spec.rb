require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = create(:user, &:confirm)
    sign_in @user
  end

  describe 'ユーザー編集' do
    context '正常系' do
      it '登録情報編集画面が描画されていること' do
        get :edit
        expect(response).to render_template 'users/edit'
      end
    end
  end

  describe 'マイページ表示' do
    context '正常' do
      it 'マイページが描画されていること' do
        get :show
        expect(response).to render_template 'users/show'
      end
    end
  end
end