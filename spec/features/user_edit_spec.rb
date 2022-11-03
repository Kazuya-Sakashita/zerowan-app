require 'rails_helper'

RSpec.feature '会員情報編集', type: :feature do
  before do
    #会員登録画面に行く
    visit new_user_registration_path
    ActionMailer::Base.deliveries.clear
  end

  describe 'プロフィール編集画面' do
    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end

    before do
      sign_in user
      visit edit_users_path
    end

    describe 'プロフィール' do
      context '正常系' do
        scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
          expect(page).to have_field 'アバター'
          expect(page).to have_field 'お名前', with: user.profile.name
          expect(page).to have_field 'ご住所', with: user.profile.address
          expect(page).to have_field 'お電話番号', with: user.profile.phone_number
          expect(page).to have_field '生年月日', with: user.profile.birthday.strftime("%Y-%m-%d")
          expect(page).to have_field '飼主経験', with: user.profile.breeding_experience
          expect(page).to have_button 'プロフィール内容変更'
          expect(page).to have_field 'メールアドレス', with: user.email
          expect(page).to have_button 'アカウント情報更新'
        end
        scenario 'プロフィール正しく値を入力した場合、ユーザーのマイページ画面に遷移すること' do
          attach_file 'アバター', 'spec/fixtures/images/dog2.jpeg'
          fill_in 'お名前', with: 'KAZUYA'
          fill_in 'ご住所', with: '大阪市'
          fill_in 'お電話番号', with: '00000000000'
          fill_in '生年月日', with: '2022-06-26'
          fill_in '飼主経験', with: '猫1年'
          click_button 'プロフィール内容変更'
          expect(page).to have_current_path users_path
        end
      end

      context '異常系' do
        scenario 'プロフィール正しく値を入力なかった場合、バリデーションエラーの内容が表示されること' do
          attach_file 'アバター', nil
          fill_in 'お名前', with: nil
          fill_in 'ご住所', with: nil
          fill_in 'お電話番号', with: nil
          fill_in '生年月日', with: nil
          fill_in '飼主経験', with: nil
          click_button 'プロフィール内容変更'
          expect(page).to have_content 'お名前入力されていません。'
          expect(page).to have_content 'ご住所入力されていません。'
          expect(page).to have_content 'お電話番号入力されていません。'
          expect(page).to have_content 'お電話番号が無効です。'
          expect(page).to have_content '生年月日入力されていません。'
          expect(page).to have_content '飼主経験入力されていません。'
        end
      end
    end
  end

  describe 'アカウント情報' do
    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end

    before do
      sign_in user
      visit edit_users_path
    end

    context '正常系' do
      before do
        fill_in 'メールアドレス', with: 'test123456789@test.com'
        fill_in '現在のパスワード', with: 'password'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認用）', with: 'password123'
        click_button 'アカウント情報更新'
      end
      scenario 'アカウント情報を正しく入力した場合、Home 画面に遷移すること' do
        binding.pry
        expect(page).to have_current_path root_path
      end
      scenario 'アカウント情報を正しく入力した場合、flash メッセージが正しく表示されること' do
        expect(page).to have_content 'アカウント情報を変更しました。'
      end
    end

    context '異常系' do
      scenario 'アカウント情報を正しく入力しなかった場合、flash メッセージが正しく表示されること' do
        fill_in 'メールアドレス', with: 'test123456789@test.com'
        fill_in '現在のパスワード', with: nil
        fill_in 'パスワード', with: nil
        fill_in 'パスワード（確認用）', with: nil
        click_button 'アカウント情報更新'
        expect(page).to have_content '変更する場合は現在のパスワードを入力してください。'
      end

      scenario '現在のパスワードを入力し、email を入力しなかった場合、バリデーションエラーの内容が表示されること' do
        fill_in 'メールアドレス', with: nil
        fill_in '現在のパスワード', with: 'password'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認用）', with: 'password123'
        click_button 'アカウント情報更新'
        expect(page).to have_content 'メールアドレス入力されていません。'
      end
      scenario '現在のパスワードを入力し、パスワードと確認用パスワードが異なっていた場合、バリデーションエラーの内容が表示されること' do
        fill_in 'メールアドレス', with: 'test123456789@test.com'
        fill_in '現在のパスワード', with: '20220828'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認用）', with: 'password123'
        click_button 'アカウント情報更新'
        expect(page).to have_content '現在のパスワードが違います。'
      end
    end
  end
end