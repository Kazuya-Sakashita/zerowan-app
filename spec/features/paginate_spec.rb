require 'rails_helper'
# TODO 定数管理の整備をしてからモックを使ったテストを実証

# RSpec.feature 'ページネーション表示', type: :feature do
  # let(:user) do
  #   create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
  # end
  #
  # before do
  #   create(:area, place_name: '大阪')
  #     create_list(:pet,21,
  #            category: :dog,
  #            petname: 'taro20221101',
  #            age: 12,
  #            gender: :male,
  #            classification: :Chihuahua,
  #            introduction: 'おとなしく、賢い',
  #            castration: :neutered,
  #            vaccination: :vaccinated,
  #            recruitment_status: 0,
  #            user_id: user.id)
  #   visit root_path
  # end
  #
  # describe 'ページネーション' do
  #   scenario '正しく表示されていること' do
  #     expect(page).to have_selector '.pagination', text: '1 2 Next Last'
  #   end
  #
  #   scenario '正しく機能すること' do
  #     click_link '2'
  #     expect(page).to have_current_path root_path(page: '2')
  #     click_link 'First'
  #     expect(page).to have_current_path root_path('/')
  #     click_link 'Last'
  #     expect(page).to have_current_path root_path(page: '2')
  #   end
  # end
# end