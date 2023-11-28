require 'rails_helper'

RSpec.feature 'マイページ表示', type: :feature do
    before do
      @user = create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
      create(:pet, petname: 'taro20221101', user: @user)
      sign_in @user
      visit users_path
    end

    describe 'ペット一覧表示' do
        scenario '自分の投稿が表示されていること' do
          expect(page).to have_content 'taro20221101'
        end

        scenario '他ユーザーの投稿が含まれないこと' do
          user1 = create(:user, email: 'test@test.com', password: 'password', password_confirmation: 'password', &:confirm)
          create(:pet, petname: 'test20221101', user: user1)
          expect(page).not_to have_content 'test20221101'
        end
      end

      describe 'お知らせ表示' do
        let!(:owned_user) { create(:user, &:confirm) }
        let!(:joined_user) { create(:user, &:confirm) }
        let!(:pet) { create(:pet, user: owned_user) }

        let!(:joined_room) do
          room = create(:room, user: joined_user, owner: owned_user, pet: pet)
            create(:message, room: room, user: joined_user, body: "テストメッセージ")
          room
        end

        context '新着メッセーがある場合' do
          before do
            sign_in owned_user

            $redis.sadd("user:#{owned_user.id}:unread_messages_in_rooms", joined_room.id)
            visit users_path
          end

          scenario '新着メッセージがあります。が表示されていること' do
            expect(page).to have_content '新着メッセージがあります'
          end
        end

        context '新着メッセーがない場合' do
          before do
            sign_in joined_user
            visit users_path
          end

          scenario 'お知らせはありません。が表示されていること' do
            expect(page).to have_content 'お知らせはありません。'
          end
        end
      end
    end
