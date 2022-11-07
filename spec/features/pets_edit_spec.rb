require 'rails_helper'

RSpec.feature 'ペット詳細情報', type: :feature do
  before do
    @user = create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    create(:pet,
           category: :dog,
           petname: 'taro20221101',
           age: 12,
           gender: :male,
           classification: :Chihuahua,
           introduction: 'おとなしく、賢い',
           castration: :neutered,
           vaccination: :vaccinated,
           recruitment_status: 0,
           user: @user)

    sign_in @user
    visit users_path
    click_link 'ペット詳細情報を確認'
    click_link 'ペット情報を編集する'
  end

  describe 'ペット情報編集画面' do
    context '画面表示' do
      scenario '表示される内容が正しいこと（リンク等が正しく表示されていること）' do
        expect(page).to have_field 'カテゴリ', with: 'dog'
        expect(page).to have_field 'ペットのお名前', with: 'taro20221101'
        expect(page).to have_field '年齢', with: 12
        expect(page).to have_field '性別', with: 'male'
        expect(page).to have_field '種別', with: 'Chihuahua'
        expect(page).to have_field 'ペットのご紹介', with: 'おとなしく、賢い'
        expect(page).to have_field 'ワクチン接種有無', with: 'vaccinated'
        expect(page).to have_field '去勢有無', with: 'neutered'
      end
    end
    context '正常系' do
      before do
        attach_file '画像選択', "#{Rails.root}/spec/fixtures/images/Dachshund3.jpeg"
        select 'イヌ', from: 'カテゴリ'
        fill_in 'ペットのお名前', with: 'SORA'
        select 'オス', from: '性別'
        fill_in '年齢', with: '3'
        select 'チワワ', from: '種別'
        fill_in 'ペットのご紹介', with: '内弁慶'
        select '接種済', from: 'ワクチン接種有無'
        select '未去勢', from: '去勢有無'
        click_button 'ペット情報変更'
      end

      scenario 'ペット情報を正しく値を入力した場合、ペット詳細画面に遷移すること' do
        expect(page).to have_current_path pet_path(Pet.last.id)
      end

      scenario 'ペット情報を正しく値を入力した場合、flash メッセージが正しく表示されていること' do
        expect(page).to have_content '登録完了しました。'
        expect(page).to have_content 'SORA'
        expect(page).to have_content  '3'
        expect(page).to have_content '内弁慶'
      end

    end
    context '異常系' do
      before do
        attach_file '画像選択', nil
        select 'イヌ', from: 'カテゴリ'
        fill_in 'ペットのお名前', with: nil
        select 'オス', from: '性別'
        fill_in '年齢', with: nil
        select 'チワワ', from: '種別'
        fill_in 'ペットのご紹介', with: nil
        select '接種済', from: 'ワクチン接種有無'
        select '未去勢', from: '去勢有無'
        click_button 'ペット情報変更'
      end
      scenario 'ペット情報を正しく値を入力しなかったた場合、ペット情報編集画面に遷移すること' do
        expect(page).to have_current_path edit_pet_path(Pet.last.id)
      end

      scenario 'ペット情報を正しく値を入力しなかったた場合、バリデーションエラーの内容が表示されること' do
        expect(page).to have_content 'ペットのお名前を入力してください'
        expect(page).to have_content 'ペットのご紹介を入力してください'
        expect(page).to have_content '年齢を入力してください'
      end

    end
  end
end