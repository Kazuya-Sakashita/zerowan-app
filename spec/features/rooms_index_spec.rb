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
          room = create(:room, user: joined_user, owner: owned_user, pet:)
          create(:message, room:, user: joined_user, body: 'テストメッセージ')
          rooms << room
        end
      end
      rooms
    end

    before do
      sign_in joined_users.first
      allow(Settings.pagination.per).to receive(:room).and_return(10)
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

  describe 'ページネーションのテスト' do
    # 11件のルームとメッセージを作成
    let!(:rooms) do
      (1..11).map do |i|
        pet = create(:pet, user: owned_user)
        room = create(:room, user: joined_users.first, owner: owned_user, pet:)
        create(:message, room:, user: joined_users.first, body: "テストメッセージ#{i}",
                         created_at: Time.current + i.minutes)
        room
      end
    end

    before do
      sign_in joined_users.first
      allow(Settings.pagination.per).to receive(:room).and_return(10)
      visit rooms_path
    end

    scenario '1ページ目に最新の10件のルームが表示されること' do
      # 最新の10件なので2から11までを確認
      (2..11).each do |i|
        expect(page).to have_content(/(^|\W)テストメッセージ#{i}($|\W)/) # \Wは単語の境界を示す
      end
      expect(page).not_to have_content(/(^|\W)テストメッセージ1($|\W)/)
    end

    scenario '2ページ目に最古のルームが表示されること' do
      click_link 'Next'

      expect(page).to have_content(/(^|\W)テストメッセージ1($|\W)/)
      (2..11).each do |i|
        expect(page).not_to have_content(/(^|\W)テストメッセージ#{i}($|\W)/)
      end
    end
  end
end
