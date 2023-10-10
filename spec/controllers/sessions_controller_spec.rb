require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  let!(:user) do
    create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
  end

  context 'ログイン画面' do
    it 'ログイン画面が描画されていること' do
      get :new
      expect(response).to render_template 'devise/sessions/new'
    end
  end

  context 'ログイン' do
    before do
      post :create, params: { user: { email: 'test123456789@test.com', password: 'password' } }
    end

    it '正しく値が入力された場合、ユーザーのマイページ画面が描画されること' do
      expect(response).to redirect_to users_path
    end

    it '正しく値が入力された場合、flash メッセージが正しく表示されること' do
      expect(flash[:notice]).to eq 'ログインしました。'
    end

    it '正しく値が入力された場合、ユーザーがログイン状態であること' do
      expect(controller).to be_user_signed_in
    end
  end

  context 'ログアウト' do
    before do
      sign_in user
    end

    it 'Home 画面が描画されること' do
      delete :destroy
      expect(response).to redirect_to root_path
    end

    it 'flash メッセージが正しく表示されること' do
      delete :destroy
      expect(flash[:notice]).to eq 'ログアウトしました。'
    end

    it 'ユーザーがログイン状態ではないこと' do
      delete :destroy
      expect(controller).not_to be_user_signed_in
    end
  end
end
