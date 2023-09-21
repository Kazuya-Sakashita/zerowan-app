require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe '.create' do
    let!(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end

    before do
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

  describe '.edit' do

    let!(:owned_user) { create(:user, &:confirm) }
    let!(:joined_user) { create(:user, &:confirm) }
    let!(:other_user) { create(:user, &:confirm) }
    let!(:pet) { create(:pet, user_id: owned_user.id) }
    let!(:room_owned_by_user) { create(:room, owner: owned_user, user: joined_user, pet: pet) }
    let!(:message) { create(:message, room:room_owned_by_user, user: joined_user, body:'coment test 1') }

    context 'ユーザーが認証されていない場合' do
      before { get :edit, params: { id: message.id } }

      it 'ログインページにリダイレクトすること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'メッセージの所有者である場合' do
      before do
        sign_in joined_user
        get :edit, params: { id: message.id }
      end

      it 'editテンプレートが表示されること' do
        expect(response).to render_template(:edit)
      end
    end

    context 'メッセージの所有者でない場合' do
      before do
        sign_in other_user
        get :edit, params: { id: message.id }
      end

      it 'ルームのページにリダイレクトし、アラートが表示されること' do
        expect(response).to redirect_to(room_path(message.room_id))
        expect(flash[:alert]).to eq '他のユーザーのメッセージを編集することはできません。'
      end
    end
  end

  describe '.update' do
    let!(:owned_user) { create(:user, &:confirm) }
    let!(:joined_user) { create(:user, &:confirm) }
    let!(:other_user) { create(:user, &:confirm) }
    let!(:pet) { create(:pet, user_id: owned_user.id) }
    let!(:room_owned_by_user) { create(:room, owner: owned_user, user: joined_user, pet: pet) }
    let!(:message) { create(:message, room: room_owned_by_user, user: joined_user, body: 'comment test 1') }
    let(:valid_params) { { body: 'updated comment' } }
    let(:invalid_params) { { body: '' } } 

    context 'メッセージの所有者が更新を試みる場合' do
      before { sign_in joined_user }

      it 'メッセージが正常に更新されること' do
        put :update, params: { id: message.id, message: valid_params }
        message.reload
        expect(message.body).to eq 'updated comment'
        expect(response).to redirect_to(room_path(message.room_id))
        expect(flash[:notice]).to eq 'メッセージが更新されました。'
      end

      context '無効なパラメータが送られた場合' do
        it 'メッセージが更新されず、editページが再表示されること' do
          put :update, params: { id: message.id, message: invalid_params }
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'メッセージの所有者ではないユーザーが更新を試みる場合' do
      before { sign_in owned_user }

      it 'メッセージが更新されないこと' do
        original_body = message.body
        put :update, params: { id: message.id, message: valid_params }
        message.reload
        expect(message.body).to eq original_body
      end
    end
  end

  describe '.destroy' do

    let!(:owned_user) { create(:user, &:confirm) }
    let!(:joined_user) { create(:user, &:confirm) }
    let!(:other_user) { create(:user, &:confirm) }
    let!(:pet) { create(:pet, user_id: owned_user.id) }
    let!(:room_owned_by_user) { create(:room, owner: owned_user, user: joined_user, pet: pet) }
    let!(:message) { create(:message, room: room_owned_by_user, user: joined_user, body: 'comment test 1') }


    context 'メッセージが正常に削除された場合' do

      before { sign_in joined_user }

      it 'メッセージが削除されること' do
        expect {
          delete :destroy, params: { id: message.id }
        }.to change(Message, :count).by(-1)
      end

      it 'roomのページにリダイレクトされること' do
        delete :destroy, params: { id: message.id }
        expect(response).to redirect_to(room_path(message.room_id))
      end

      it '成功のフラッシュメッセージが表示されること' do
        delete :destroy, params: { id: message.id }
        expect(flash[:notice]).to eq 'メッセージが削除されました。'
      end
    end

    context 'メッセージが削除に失敗した場合' do
      before do
        sign_in joined_user
        allow_any_instance_of(Message).to receive(:destroy).and_return(false)
      end

      it 'メッセージが削除されないこと' do
        expect {
          delete :destroy, params: { id: message.id }
        }.to_not change(Message, :count)
      end

      it 'roomのページにリダイレクトされること' do
        delete :destroy, params: { id: message.id }
        expect(response).to redirect_to(room_path(message.room_id))
      end

      it 'エラーのフラッシュメッセージが表示されること' do
        delete :destroy, params: { id: message.id }
        expect(flash[:alert]).to eq 'メッセージが削除に失敗しました。'
      end
    end

    context 'メッセージの所有者ではないユーザーが削除を試みる場合' do
      before { sign_in owned_user }

      it 'メッセージが削除されないこと' do
        expect {
          delete :destroy, params: { id: message.id }
        }.to_not change(Message, :count)
      end
    end
  end
end
