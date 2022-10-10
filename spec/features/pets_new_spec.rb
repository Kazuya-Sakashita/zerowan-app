require 'rails_helper'

RSpec.feature '里親募集（登録）', type: :feature do
  let(:user) do
    create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
  end

  before do
    sign_in user
    visit new_pet_path
  end

  describe '里親募集登録' do
    context '正常系' do
      scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
        expect(page).to have_content '紹介画像'
        expect(page).to have_content 'カテゴリ'
        expect(page).to have_content 'ペットのお名前'
        expect(page).to have_content '性別'
        expect(page).to have_content '年齢'
        expect(page).to have_content '種別'
        expect(page).to have_content 'ペットのご紹介'
        expect(page).to have_content 'ワクチン接種有無'
        expect(page).to have_content '去勢有無'

        expect(page).to have_field 'pet_form[photos][]'
        expect(page).to have_field 'pet[category]'
        expect(page).to have_field 'pet[petname]'
        expect(page).to have_field 'pet[gender]'
        expect(page).to have_field 'pet[age]'
        expect(page).to have_field 'pet[classification]'
        expect(page).to have_field 'pet[introduction]'
        expect(page).to have_field 'pet[vaccination]'
        expect(page).to have_field 'pet[castration]'

        expect(page).to have_button '登録内容確認'

        # セレクトボックスの選択肢のテスト
        expect(page).to have_select('カテゴリ', options: %w!イヌ ネコ その他!)
        expect(page).to have_select('性別', options: %w!不明 オス メス!)
        expect(page).to have_select('種別', options: %w!チワワ ダックス その他!)
        expect(page).to have_select('ワクチン接種有無', options: %w!不明 接種済 未接種!)
        expect(page).to have_select('去勢有無', options: %w!不明 去勢済 未去勢!)
      end

      scenario '正しく値を入力した場合、flash メッセージが正しく表示されていること' do
        attach_file '紹介画像', "#{Rails.root}/spec/fixtures/images/Dachshund3.jpeg"
        select 'イヌ', from: 'カテゴリ'
        fill_in 'ペットのお名前', with: 'Sora'
        select 'オス', from: '性別'
        fill_in '年齢', with: '3'
        select 'チワワ', from: '種別'
        fill_in 'ペットのご紹介', with: 'おとなしく、賢い'
        select '接種済', from: 'ワクチン接種有無'
        select '未去勢', from: '去勢有無'
        click_button '登録内容確認'
        expect(page).to have_content '登録完了しました。'
        expect(current_path).to eq pet_path(Pet.last)
      end
    end

    context '異常系' do
      scenario '値が全て入力されていなかった場合、バリデーションエラーの内容が表示されること' do
        attach_file '紹介画像', nil
        select 'イヌ', from: 'カテゴリ'
        fill_in('ペットのお名前', with: nil, fill_options: { clear: :backspace })
        select 'オス', from: '性別'
        fill_in '年齢', with: '3'
        select 'チワワ', from: '種別'
        fill_in('ペットのご紹介', with: nil, fill_options: { clear: :backspace })
        select '接種済', from: 'ワクチン接種有無'
        select '未去勢', from: '去勢有無'
        click_button '登録内容確認'
        expect(current_path).to eq new_pet_path
        expect(page).to have_content 'ペットのお名前を入力してください'
        expect(page).to have_content 'ペットのご紹介を入力してください'
        # selectについては入力なくても基本選択されている状態、入力は確認は'ペットのお名前'、'ペットのご紹介'としている。
      end

      scenario '画像が添付されていなかった場合、バリデーションエラーの内容が表示されること' do
        attach_file '紹介画像', nil
        select 'イヌ', from: 'カテゴリ'
        fill_in('ペットのお名前', with: 'タロウ', fill_options: { clear: :backspace })
        select 'オス', from: '性別'
        fill_in '年齢', with: '3'
        select 'チワワ', from: '種別'
        fill_in('ペットのご紹介', with: '優しい', fill_options: { clear: :backspace })
        select '接種済', from: 'ワクチン接種有無'
        select '未去勢', from: '去勢有無'
        click_button '登録内容確認'
        expect(current_path).to eq new_pet_path
        expect(page).to have_content '紹介画像添付枚数を確認してください。'
      end
    end
  end
end
