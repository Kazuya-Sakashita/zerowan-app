require 'rails_helper'

RSpec.feature '里親募集', type: :feature do
  before do
    user = create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
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
           user: user)

    sign_in user
    visit root_path
    click_link 'ペット詳細情報を確認'
  end

  context 'ペット詳細情報画面表示' do
    scenario 'ペット一覧から遷移ができること' do
      expect(current_path).to eq pet_path(Pet.last)
    end

    scenario 'ペットの詳細が表示されていること' do
      expect(page).to have_content 'taro20221101'
      expect(page).to have_content 'オス'
      expect(page).to have_content '12才'
      expect(page).to have_content 'チワワ'
      expect(page).to have_content 'おとなしく'
      expect(page).to have_content '接種済'
      expect(page).to have_content '去勢済'
    end
  end

  context '編集ページへと遷移するボタン表示' do

    scenario '自身の投稿の場合、表示していること' do
      expect(page).to have_link 'ペット情報を編集する'
    end

    before do
      other_user = create(:user, email: 'test20221104@test.com', password: 'password', password_confirmation: 'password', &:confirm)
      create(:pet,
             category: :dog,
             petname: 'test20221104',
             age: 12,
             gender: :male,
             classification: :Chihuahua,
             introduction: 'おとなしく、賢い',
             castration: :neutered,
             vaccination: :vaccinated,
             recruitment_status: 0,
             user: other_user)
    end

    scenario '他者投稿の表示していないこと' do
      visit pet_path(Pet.last.id)
      expect(page).not_to have_link 'ペット情報を編集する'
      expect(page).to have_content 'test20221104'
    end
  end

  describe 'お気に入り機能' do
    before do
      user_favorite = create(:user, email: 'test121212@test.com', password: 'password', password_confirmation: 'password', &:confirm)
      sign_in  user_favorite
      visit pet_path(Pet.last)
    end
    scenario 'お気に入り登録できること' do
      click_button '★ 気になるリストに追加'
      expect(page).to have_content '☆ 気になるリストから削除'
    end

    scenario 'お気に入り削除できること' do
      click_button '★ 気になるリストに追加'

      click_button '☆ 気になるリストから削除'
      expect(page).to have_content '★ 気になるリストに追加'
    end
  end
end


