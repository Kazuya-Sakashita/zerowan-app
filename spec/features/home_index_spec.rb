require 'rails_helper'

RSpec.feature 'ホーム画面', type: :feature do
  before do
    @user = create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    @area = create(:area, place_name: '大阪')
    @pet = create(:pet,
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
    @pet_area = create(:pet_area, pet_id: @pet.reload.id, area_id: @area.reload.id)
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
  describe '検索機能' do
    before do
      create(:area, place_name: '東京')
    end

    scenario '正しく値を入力した場合、検索ができること' do
      visit root_path
      select 'イヌ', from: 'q_category_eq'
      select 'オス', from: 'q_gender_eq'
      fill_in 'q_age_lteq', with: '12'
      select 'チワワ', from: 'q_classification_eq'
      check '大阪'
      click_button '検索する'
      expect(page).to have_content 'taro20221101'
    end

    scenario '正しく値を入力しなかったた場合、検索ができないこと' do
      visit root_path
      select 'ネコ', from: 'q_category_eq'
      select 'メス', from: 'q_gender_eq'
      fill_in 'q_age_lteq', with: '13'
      select 'ダックス', from: 'q_classification_eq'
      check '東京'
      click_button '検索する'
      expect(page).not_to have_content 'taro20221101'
    end
  end
end