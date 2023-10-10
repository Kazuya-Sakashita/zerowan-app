require 'rails_helper'

RSpec.feature 'ログイン認証', type: :feature do
  let(:admin) { create(:admin) }

  describe 'ログイン' do
    before do
      visit new_admin_session_path
    end

    scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
      expect(page).to have_content 'メールアドレス'
      expect(page).to have_content 'パスワード'
      expect(page).to have_button 'ログイン'
    end

    context '正しく値を入力した場合' do
      scenario '管理者画面に遷移すること' do
        fill_in 'メールアドレス', with: "#{admin.email}"
        fill_in 'パスワード', with: "#{admin.password}"
        click_button 'ログイン'
        expect(current_path).to eq admins_home_index_path
      end

      scenario 'flash メッセージが正しく表示されること' do
        fill_in 'メールアドレス', with: "#{admin.email}"
        fill_in 'パスワード', with: "#{admin.password}"
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました。'
      end
    end

      context '正しく値を入力しなかった場' do
        scenario 'flash メッセージが正しく表示されること' do
          fill_in 'メールアドレス', with: nil
          fill_in 'パスワード', with: nil
          click_button 'ログイン'
          expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        end
      end
  end

  describe 'ログアウト' do
    before do
      sign_in admin
      visit admins_home_index_path
    end

    scenario 'ログイン 画面に遷移すること' do
      click_link '管理者ログアウト'
      expect(current_path).to eq new_admin_session_path
    end

    scenario 'flash メッセージが正しく表示されること' do
      click_link '管理者ログアウト'
      expect(page).to have_content 'ログアウトしました。'
    end
  end
end
