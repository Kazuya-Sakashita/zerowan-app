require 'rails_helper'

RSpec.feature 'members/index', type: :feature do
  let!(:owned_user) { create(:user, &:confirm) }
  let!(:joined_user) { create(:user, &:confirm) }
  let!(:pets) { create_list(:pet, 4, user: owned_user) }

  let!(:joined_room) do
    room = create(:room, user: joined_user, owner: owned_user, pet: pets.first)
      create(:message, room: room, user: joined_user, body: "テストメッセージ")
      create(:message, room: room, user: owned_user, body: "オーナーからの返信")
    room
  end


  describe '掲載中の募集がない場合' do

    before do
      sign_in joined_user
      visit members_pets_path(user_id: joined_user.id)
    end

      it "現在掲載中の募集はありませんが表示される" do
        expect(page).to have_content("現在掲載中の募集はありません。")
      end
  end

  describe '掲載中の募集がある場合' do
    before do
      sign_in joined_user
      visit members_pets_path(user_id: owned_user.id)
    end

    context 'ペットが4つ未満の場合' do
      scenario 'もっと見るリンクが表示されていないこと' do
        expect(page).not_to have_content("もっと見る")
      end
    end

    context 'ペットが4つ以上の場合' do
      before do
        create(:pet, user: owned_user) #ペットを追加し、登録数5にする
        visit members_pets_path(user_id: owned_user.id)
      end

      scenario 'もっと見るリンクが表示されていること' do
        expect(page).to have_content("もっと見る")
      end

      scenario 'もっと見るリンクを押すともっと見るが消える' do
        click_link 'もっと見る'
        expect(page).not_to have_content("もっと見る")
      end
    end
  end




end