require 'rails_helper'

RSpec.feature 'ページネーション表示', type: :feature do
  let(:user) do
    create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
  end

  before do
    create(:area, place_name: '大阪')
      create_list(:pet,60,
             category: :dog,
             petname: 'taro20221101',
             age: 12,
             gender: :male,
             classification: :Chihuahua,
             introduction: 'おとなしく、賢い',
             castration: :neutered,
             vaccination: :vaccinated,
             recruitment_status: 0,
             user_id: user.id)
    visit root_path
  end

  describe '20件以上登録がある場合' do
    scenario 'ページネーションが表示されていること' do
      expect(page).to have_selector '.pagination', text: '1 2 3 Next Last'
    end

    scenario 'ページネーションが正しく機能すること' do
      click_link '2'
      expect(page).to have_current_path root_path(page: '2')
      click_link '3'
      expect(page).to have_current_path root_path(page: '3')
      click_link 'First'
      expect(page).to have_current_path root_path('/')
      click_link 'Last'
      expect(page).to have_current_path root_path(page: '3')
    end

  end
end