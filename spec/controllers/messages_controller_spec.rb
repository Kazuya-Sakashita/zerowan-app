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

    context 'showアクション' do
      it 'petへの問い合わせが初めての場合、ルームテーブルに登録' do
        expect do
          get :show, params: { pet_id: @pet.id, id: @pet.id }
        end.to change { Room.count }.by(1)
      end

      it 'petへの問い合わせが2回目以降の場合、ルームテーブルに登録しない' do
        @message = get :show, params: { pet_id: @pet.id, id: @pet.id }
        expect do
          get :show, params: { pet_id: @pet.id, id: @pet.id }
        end.to change { Room.count }.by(0)
      end
    end

    context 'createアクション' do
      let(:headers){ { 'HTTP_REFERER' => referer } }
      let!(:referer){"/pets/#{@pet.id}/messages/show"}

      before do
        get :show, params: { pet_id: @pet.id, id: @pet.id }
        @room = Room.last
        request.headers.merge! headers
      end

      it 'パラーメーターが正しく設定されて場合、メッセージが保存できる' do
        params = { pet_id: @pet.id , user_id: user.id, message: {body: "はじめまして"}, room_id: @room.id }
        expect do
          post :create, params:params
        end.to change { Message.count }.by(1)
      end
    end
  end
end