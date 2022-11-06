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
    context '正常系' do
      scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
        expect(page).to have_field 'カテゴリ', with: 'dog'
        expect(page).to have_field 'ペットのお名前', with: 'taro20221101'
        expect(page).to have_field '年齢', with: 12
        expect(page).to have_field '性別', with: 'male'
        expect(page).to have_field '種別', with: 'Chihuahua'
        expect(page).to have_field 'ペットのご紹介', with: 'おとなしく、賢い'
        expect(page).to have_field 'ワクチン接種有無', with: 'vaccinated'
        expect(page).to have_field '去勢有無', with: 'neutered'
        expect(page).to have_button 'ペット情報変更'
      end

      scenario 'ペット情報を正しく値を入力した場合、ペット詳細画面に遷移すること' do
        attach_file '画像選択', "#{Rails.root}/spec/fixtures/images/Dachshund3.jpeg"
        select 'イヌ', from: 'カテゴリ'
        fill_in 'ペットのお名前', with: 'SORA'
        select 'オス', from: '性別'
        fill_in '年齢', with: '3'
        select 'チワワ', from: '種別'
        fill_in 'ペットのご紹介', with: '内弁慶'
        select '接種済', from: 'ワクチン接種有無'
        select '未去勢', from: '去勢有無'
        binding.pry
        click_button 'ペット情報変更'
        expect(page).to have_current_path pet_path(Pet.last.id)
      end

    end
  end
end