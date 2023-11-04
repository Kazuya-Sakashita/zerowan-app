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
end
