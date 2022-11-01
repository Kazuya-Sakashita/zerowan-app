require 'rails_helper'

RSpec.feature 'ホーム画面', type: :feature do
  before do
    @user = create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    create(:pet, petname: 'taro20221101', user: @user)
  end

  describe 'ペット一覧表示' do
    scenario '未ログイン状態で表示されていること' do
      visit root_path
      expect(page).to have_content 'taro20221101'
    end

    scenario 'ログイン状態で表示されていること' do
      sign_in @user
      visit root_path
      expect(page).to have_content 'taro20221101'
    end
  end
end