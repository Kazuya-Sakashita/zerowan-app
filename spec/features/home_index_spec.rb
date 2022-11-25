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
    context '組合せ検索' do
      scenario '正しく値を入力した場合、検索結果があること' do
        visit root_path
        select 'イヌ', from: 'q_category_eq'
        select 'オス', from: 'q_gender_eq'
        fill_in 'q_age_lteq', with: '12'
        select 'チワワ', from: 'q_classification_eq'
        check '大阪'
        click_button '検索する'
        expect(page).to have_content 'taro20221101'
      end
    end

    context '個々検索' do
      context 'カテゴリ' do
        scenario 'カテゴリでの登録がある場合、検索結果があること' do
          visit root_path
          select 'イヌ', from: 'q_category_eq'
          click_button '検索する'
          expect(page).to have_content 'taro20221101'
        end
        scenario 'カテゴリでの登録がない場合、検索結果がないこと' do
          visit root_path
          select 'ネコ', from: 'q_category_eq'
          click_button '検索する'
          expect(page).not_to have_content 'taro20221101'
        end
      end

      context '性別' do
        scenario '性別での登録がある場合、検索結果があること' do
          visit root_path
          select 'オス', from: 'q_gender_eq'
          click_button '検索する'
          expect(page).to have_content 'taro20221101'
        end
        scenario '性別での登録がない場合、検索結果がないこと' do
          visit root_path
          select 'メス', from: 'q_gender_eq'
          click_button '検索する'
          expect(page).not_to have_content 'taro20221101'
        end
      end
      context '年齢' do
        scenario '年齢の登録範囲内（より若い）の場合、検索結果があること' do
          visit root_path
          fill_in 'q_age_lteq', with: '12'
          click_button '検索する'
          expect(page).to have_content 'taro20221101'
        end
        scenario '年齢の登録範囲内（より若い）でない場合、検索結果がないこと' do
          visit root_path
          fill_in 'q_age_lteq', with: '11'
          click_button '検索する'
          expect(page).not_to have_content 'taro20221101'
        end
      end
      context '種別' do
        scenario '種別での登録がある場合、検索結果があること' do
          visit root_path
          select 'チワワ', from: 'q_classification_eq'
          click_button '検索する'
          expect(page).to have_content 'taro20221101'
        end
        scenario '種別での登録がない場合、検索結果がないこと' do
          visit root_path
          select 'ダックス', from: 'q_classification_eq'
          click_button '検索する'
          expect(page).not_to have_content 'taro20221101'
        end
      end

      context '譲渡可能地域' do
        scenario '譲渡可能地域での登録がある場合、検索結果があること' do
          visit root_path
          check '大阪'
          click_button '検索する'
          expect(page).to have_content 'taro20221101'
        end
        scenario '譲渡可能地域での登録がない場合、検索結果がないこと' do
          visit root_path
          check '東京'
          click_button '検索する'
          expect(page).not_to have_content 'taro20221101'
        end
      end

      context '複数譲渡可能地域登録検索' do
        before do
          create(:area, place_name: '和歌山') do |area|
            create(:pet_area, pet_id: @pet.id, area_id: area.id)
          end
          create(:area, place_name: '兵庫') do |area|
            create(:pet_area, pet_id: @pet.id, area_id: area.id)
          end
          create(:area, place_name: '奈良') do |area|
            create(:pet_area, pet_id: @pet.id, area_id: area.id)
          end
        end
        scenario '複数の譲渡可能地域が登録されている且つ複数の譲渡可能地域を指定した場合、検索結果があること' do
          visit root_path
          check '大阪'
          check '和歌山'
          check '兵庫'
          check '奈良'
          click_button '検索する'
          expect(page).to have_content 'taro20221101'
        end
      end
    end
  end
end