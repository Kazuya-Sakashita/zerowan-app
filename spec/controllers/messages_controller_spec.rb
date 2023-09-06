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

    context 'パラーメーターが正しく設定されている場合' do
      let(:headers){ { 'HTTP_REFERER' => referer } }
      let!(:referer){"/pets/#{@pet.id}/rooms"}

      before do
        request.headers.merge! headers
        @room = @pet.rooms.create(user_id: user.id, pet_id: @pet.id, owner_id: @pet.user_id)
      end

      it 'メッセージが保存できること' do
        params = { pet_id: @pet.id , user_id: user.id, message: {body: "はじめまして"}, room_id: @room.id }
        expect do
          post :create, params:params
        end.to change { Message.count }.by(1)
      end
    end

    context 'パラメーターが不正な場合' do
      let(:headers){ { 'HTTP_REFERER' => referer } }
      let!(:referer){"/pets/#{@pet.id}/rooms"}

      before do
        request.headers.merge! headers
        @room = @pet.rooms.create(user_id: user.id, pet_id: @pet.id, owner_id: @pet.user_id)
      end

      it 'メッセージが保存されないこと' do
        params = { pet_id: @pet.id , user_id: user.id, message: {body: nil}, room_id: @room.id }
        expect do
          post :create, params:params
        end.to_not change { Message.count }
      end
    end

    context 'ユーザーがログインしていない場合' do
      before do
        sign_out user
        @room = @pet.rooms.create(user_id: user.id, pet_id: @pet.id, owner_id: @pet.user_id)
      end

      it 'メッセージは保存されず、ログインページにリダイレクトされる' do
        params = { pet_id: @pet.id , user_id: user.id, message: {body: "はじめまして"}, room_id: @room.id }
        expect do
          post :create, params: params
        end.to_not change { Message.count }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
