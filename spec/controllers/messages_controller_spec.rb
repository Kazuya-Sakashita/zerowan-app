require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'メッセージ機能' do
    let!(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @pet = create(:pet)
      sign_in user
    end

    context 'newアクション' do
      it 'petへの問い合わせが初めての場合、エントリテーブルに登録' do
        expect do
          get :new, params: { pet_id: @pet.id }
        end.to change { Entry.count }.by(2)
      end

      it 'petへの問い合わせが2回目以降の場合、エントリテーブルに登録しない' do
        get :new, params: { pet_id: @pet.id }
        expect do
          get :new, params: { pet_id: @pet.id }
        end.to change { Entry.count }.by(0)
      end
      # TODO 設定内容を確認する方法が不明
      'petへの問い合わせが2回目以降の場合、ルームIDを設定する'

    end

    context 'createアクション' do
      it 'パラーメーターが正しく設定されて場合、メッセージが保存できる' do
        allow(controller).to receive(:current_user).and_return(user)
        get :new, params: { pet_id: @pet.id }
        @room_id = Room.last.id
        expect do
          binding.pry
          post :create, params: { body: "はじめまして"}
        end.to change { Message.count}.by(1)
      end
    end
  end
end