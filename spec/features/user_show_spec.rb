require 'rails_helper'

RSpec.feature 'マイページ表示', type: :feature do
    before do
      @user = create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
      create(:pet, petname: 'taro20221101', user: @user)
      sign_in @user
      visit users_path
    end

    describe 'ペット一覧表示' do
        scenario '自分の投稿が表示されていること' do
          expect(page).to have_content 'taro20221101'
        end

        scenario '他ユーザーの投稿が含まれないこと' do
          user1 = create(:user, email: 'test@test.com', password: 'password', password_confirmation: 'password', &:confirm)
          create(:pet, petname: 'test20221101', user: user1)
          expect(page).not_to have_content 'test20221101'
        end
      end
    end
