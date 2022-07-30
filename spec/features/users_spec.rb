require 'rails_helper'

RSpec.feature '会員登録', type: :feature do
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
  before do
    visit root_path
    click_link '会員登録'
  end

  scenario '登録画面へのアクセスで正常に画面が描画されること' do
    expect(page).to have_current_path('/users/sign_up')
  end

  scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
    expect(page).to have_content 'メールアドレス'
    expect(page).to have_content 'パスワード'
    expect(page).to have_content 'パスワード（確認用）'
    expect(page).to have_content 'お名前'
    expect(page).to have_content 'ご住所'
    expect(page).to have_content 'お電話番号'
    expect(page).to have_content '生年月日'
    expect(page).to have_content '飼主経験'

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
  scenario '正しく値を入力した場合、登録確認画面に遷移すること' do
    fill_in 'メールアドレス', with: 'kz0508+88@gmail.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'
    fill_in 'お名前', with: 'KAZUYA'
    fill_in 'ご住所', with: '大阪市'
    fill_in 'お電話番号', with: '00000000000'
    fill_in '生年月日', with: '2022-06-26'
    fill_in '飼主経験', with: '猫1年'
    click_button '登録内容確認'
    expect(page).to have_current_path('/users/sign_up/confirm')
    end
  scenario '値が全て入力されていなかった場合、バリデーションエラーの内容が表示されること' do
    fill_in 'メールアドレス', with: nil
    fill_in 'パスワード', with: nil
    fill_in 'パスワード（確認用）', with: nil
    fill_in 'お名前', with: nil
    fill_in 'ご住所', with: nil
    fill_in 'お電話番号', with: nil
    fill_in '生年月日', with: nil
    fill_in '飼主経験', with: nil
    click_button '登録内容確認'
    expect(page).to have_selector 'h2', text: '8 件のエラーが発生したため ユーザー は保存されませんでした。'
    expect(page).to have_selector 'li', text: 'メールアドレス 入力されていません。'
    expect(page).to have_selector 'li', text: 'パスワード 入力されていません。'
    expect(page).to have_selector 'li', text: 'ご住所 入力されていません。'
    expect(page).to have_selector 'li', text: 'お電話番号 入力されていません。'
    expect(page).to have_selector 'li', text: 'お電話番号 が無効です。'
    expect(page).to have_selector 'li', text: '生年月日 入力されていません。'
    expect(page).to have_selector 'li', text: '飼主経験 入力されていません。'
  end
end




