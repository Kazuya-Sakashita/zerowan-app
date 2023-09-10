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
          room = create(:room, user: joined_user, owner: owned_user, pet: pet)
          create(:message, room: room, user: joined_user, body: "テストメッセージ")
          rooms << room
        end
      end
      rooms
    end

  describe 'ルーム一覧（メッセージ）が表示' do
    before do
      sign_in joined_users.first
      visit rooms_path
    end

    scenario 'ログイン状態で表示されていること' do
      expect(page).to have_selector('h1', text: 'メッセージ')
      expect(page).to have_content pets.first.petname
      expect(page).to have_content pets.first.gender_i18n
      expect(page).to have_content pets.first.age
      expect(page).to have_content pets.first.introduction
      expect(page).to have_link 'こちらのメッセージに返信する'
      expect(page).to have_content 'テストメッセージ'
    end
  end


end