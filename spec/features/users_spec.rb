require 'rails_helper'

RSpec.describe User, type: :feature do
  let(:params) do
    {
      user: {
        email: "test123@test.com",
        password: "password",
        password_confirmation: "password",
        profile_attributes: {
          name: "山田太郎",
          address: "大阪市天王寺",
          phone_number: '0' * 11,
          birthday: "2010-02-11",
          breeding_experience: "犬1年",
        }
      }
    }
  end
  context '登録画面' do
    before do
      visit root_path
      click_link '会員登録'
    end

    it '登録画面へのアクセスで正常に画面が描画されること' do
      expect(page).to have_selector 'h2', text: '新規会員登録'
    end

    it '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
      expect(page).to have_field 'user[email]'
      expect(page).to have_field 'user[password]'
      expect(page).to have_field 'user[password_confirmation]'
      expect(page).to have_field 'user[profile_attributes][name]'
      expect(page).to have_field 'user[profile_attributes][address]'
      expect(page).to have_field 'user[profile_attributes][phone_number]'
      expect(page).to have_field 'user[profile_attributes][birthday]'
      expect(page).to have_field 'user[profile_attributes][breeding_experience]'
      expect(page).to have_button '登録内容確認'
    end
    it '正しく値を入力した場合、登録確認画面に遷移すること' do
      fill_in 'メールアドレス', with: 'kz0508+88@gmail.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      fill_in 'お名前', with: 'KAZUYA'
      fill_in 'ご住所', with: '大阪市'
      fill_in 'お電話番号', with: '00000000000'
      fill_in '生年月日', with: '2022-06-26'
      fill_in '飼主経験', with: '猫1年'
      find('.btn.btn-lg.comfirm-btn.btn-block').click
      expect(page).to have_selector 'h2', text: '入力情報の確認'
    end

    it '値が全て入力されていなかった場合、バリデーションエラーの内容が表示されること' do
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      fill_in 'お名前', with: 'KAZUYA'
      fill_in 'ご住所', with: '大阪市'
      fill_in 'お電話番号', with: '00000000000'
      fill_in '生年月日', with: '2022-06-26'
      fill_in '飼主経験', with: '猫1年'
      find('.btn.btn-lg.comfirm-btn.btn-block').click
      expect(page).to have_selector 'li' , text: 'メールアドレス 入力されていません。'
    end
  end
end




