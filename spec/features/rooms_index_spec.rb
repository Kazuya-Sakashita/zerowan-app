require 'rails_helper'

RSpec.feature 'rooms/index', type: :feature do
    let(:owned_user) { create(:user, &:confirm) }

    let!(:joined_users) do
      users = create_list(:user, 3)
      users.each(&:confirm)
      users
    end

    let!(:pets) { create_list(:pet, 3, user: owned_user) }


  describe 'ルーム,メッセージが存在する場合' do

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

    before do
      sign_in joined_users.first
      visit rooms_path
    end

    scenario 'ルーム一覧（メッセージ）が表示さること' do
      expect(page).to have_selector('h1', text: 'メッセージ')
      expect(page).to have_content pets.first.petname
      expect(page).to have_content pets.first.gender_i18n
      expect(page).to have_content pets.first.age
      expect(page).to have_content pets.first.introduction
      expect(page).to have_link 'こちらのメッセージに返信する'
      expect(page).to have_content 'テストメッセージ'
    end
  end

  describe 'ルームが存在しない場合' do

    before do
      sign_in joined_users.first
      visit rooms_path
    end

    scenario '表示するルームがありません。が表示さること' do
      expect(page).to have_content '表示するルームがありません。'
    end
  end

  describe 'メッセージが存在しない場合' do

    let!(:joined_rooms) do
      rooms = []
      joined_users.each do |joined_user|
        pets.each do |pet|
          room = create(:room, user: joined_user, owner: owned_user, pet: pet)
          rooms << room
        end
      end
      rooms
    end

    before do
      sign_in joined_users.first
      visit rooms_path
    end

    scenario '表示するメッセージがありません。が表示さること' do
      expect(page).to have_content '表示するメッセージがありません。'
    end
  end


end