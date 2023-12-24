require 'rails_helper'

RSpec.feature 'rooms/index', type: :feature do
  let(:owned_user) do
    create(:user, &:confirm)
  end

  let!(:joined_users) do
    users = create_list(:user, 3)
    users.each(&:confirm)
    users
  end

  let!(:pets) { create_list(:pet, 3, user: owned_user) }
  let!(:joined_rooms) do
    rooms = []
    joined_users.each do |joined_user|
      pets.each do |pet|
        room = create(:room, user: joined_user, owner: owned_user, pet:)
        create(:message, room:, user: joined_user, body: 'テストメッセージ')
        create(:message, room:, user: owned_user, body: 'オーナーからの返信')
        rooms << room
      end
    end
    rooms
  end

  describe 'メッセージ一覧表示' do
    before do
      sign_in joined_users.first
      allow(Settings.pagination.per).to receive(:message).and_return(5)
      visit room_path(joined_rooms.first)
    end

    scenario '表示されていること' do
      expect(page).to have_content "#{owned_user.profile.name}さんへのメッセージ"
      expect(page).to have_content pets.first.petname
      expect(page).to have_content pets.first.gender_i18n
      expect(page).to have_content pets.first.age
      expect(page).to have_content pets.first.introduction
      expect(page).to have_button '送信'
      expect(page).to have_content 'テストメッセージ'
      expect(page).to have_content 'オーナーからの返信'
    end
  end

  describe 'ステータス表示' do
    before do
      sign_in owned_user
      allow(Settings.pagination.per).to receive(:message).and_return(5)
      visit room_path(joined_rooms.first)
    end

    scenario '募集中の表示（アクティブ）がされていること' do
      expect(page).to have_selector('input.active[value="募集中"]')
    end

    scenario '交渉中選択で交渉中が表示（アクティブ）がされていること', js: true do
      click_button '交渉中'
      expect(page).to have_selector('input.active[value="交渉中"]')
    end

    scenario '家族決定選択で家族決定が表示（アクティブ）がされていること', js: true do
      click_button '家族決定'
      expect(page).to have_selector('input.active[value="家族決定"]')
    end

    scenario '募集中選択で募集中が表示（アクティブ）がされていること', js: true do
      click_button '交渉中'
      expect(page).to have_selector('input.active[value="交渉中"]')

      click_button '募集中'
      expect(page).to have_selector('input.active[value="募集中"]')
    end
  end
end
