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
      # TODO 評価として'/'が'/?page=2'になるような感じで実施したかったがやり方が見つからなかった
      # 押した際にページネーションが変化するため、そこをマッチャーで評価とした
      click_link '2'
      expect(page).to have_selector '.pagination', text: 'First Previous 1 2 3 Next Last'
      click_link '3'
      expect(page).to have_selector '.pagination', text: 'First Previous 1 2 3'
      click_link 'First'
      expect(page).to have_selector '.pagination', text: '1 2 3 Next Last'
      click_link 'Last'
      expect(page).to have_selector '.pagination', text: 'First Previous 1 2 3'
    end

  end
end