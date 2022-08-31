require 'rails_helper'

RSpec.feature '会員登録', type: :feature do

  let(:user) do
    create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
  end

  describe 'ログイン' do
    before do
      user.reload
      visit new_user_session_path
    end

    context '正常系' do
      scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード'
        expect(page).to have_button 'ログイン'
      end
      scenario '正しく値を入力した場合、ユーザーのマイページ画面に遷移すること' do
        fill_in 'メールアドレス', with: 'test123456789@test.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(current_path).to eq user_path(user)
      end
      scenario '正しく値を入力した場合、flash メッセージが正しく表示されること' do
        fill_in 'メールアドレス', with: 'test123456789@test.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました。'
      end
    end
    context '異常系' do
      scenario '正しく値を入力しなかった場合、flash メッセージが正しく表示されること' do
        fill_in 'メールアドレス', with: nil
        fill_in 'パスワード', with: nil
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe 'ログアウト' do
    before do
      user.reload
      visit new_user_session_path
      fill_in 'メールアドレス', with: 'test123456789@test.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end

    context '正常系' do
      scenario 'Home 画面に遷移すること' do
        click_link 'ログアウト'
        expect(current_path).to eq root_path
      end
      scenario 'flash メッセージが正しく表示されること' do
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました。'
      end
    end
  end
end