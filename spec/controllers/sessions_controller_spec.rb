require 'rails_helper'

RSpec.describe Devise::SessionsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'ログイン' do

    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end

    it 'ログイン画面が描画されていること' do
      get :new
      expect(response).to render_template 'devise/sessions/new'
    end

    before do
      user.reload
    end

    it '正しく値が入力された場合、ユーザーのマイページ画面が描画されること' do
      post :create, params: { user: { email: 'test123456789@test.com', password: 'password' } }
      expect(response).to redirect_to user_path(user)
    end

    it '正しく値が入力された場合、flash メッセージが正しく表示されること' do
      post :create, params: { user: { email: 'test123456789@test.com', password: 'password' } }
      expect(flash[:notice]).to eq 'ログインしました。'
    end
    it '正しく値が入力された場合、ユーザーがログイン状態であること' do
      post :create, params: { user: { email: 'test123456789@test.com', password: 'password' } }
      expect(controller).to be_user_signed_in
    end
  end

  describe 'ログアウト' do
    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end

    before do
      user.reload
      post :create, params: { user: { email: 'test123456789@test.com', password: 'password' } }
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