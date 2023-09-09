require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe '#new' do
    let!(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end
    let(:another_user) { create(:user) }
    let(:pet) { create(:pet, user_id: another_user.id) }

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @pet = create(:pet)
      sign_in user
    end

    context '部屋がまだ存在しない場合' do
      before do
        get :new, params: { format: pet.id }
      end

      it '適切なページ(rooms/id)にリダイレクトする' do
        expect(response).to redirect_to(room_path(Room.last))
      end

      it 'Roomを作成する' do
        expect(Room.last.pet_id).to eq(pet.id)
        expect(Room.last.user_id).to eq(user.id)
        expect(Room.last.owner_id).to eq(another_user.id)
      end

      it "部屋が作成できない場合、エラーメッセージを設定する" do
        pet = create(:pet)
        room = build(:room, pet_id: pet.id, user_id: user.id)  # 未保存のRoomインスタンス
        allow(room).to receive(:persisted?).and_return(false)  # persisted?をスタブ化

        fake_relation = instance_double("ActiveRecord::Relation", find_or_create_by: room)
        allow_any_instance_of(Pet).to receive(:rooms).and_return(fake_relation)

        get :new, params: { format: pet.id }

        expect(flash[:error]).to eq("問合せできませんでした。")
      end
    end

    context '部屋が既に存在する場合' do
      let!(:existing_room) { create(:room, pet_id: pet.id, user_id: user.id, owner_id: another_user.id) }

      before do
        get :new, params: { format: pet.id }
      end

      it '既存の部屋にリダイレクトする' do
        expect(response).to redirect_to(room_path(existing_room))
      end
    end
    end

  describe '#index' do

    let!(:owned_user) do
      user = create(:user)
      user.confirm
      user
    end

    let!(:owned_user) do
      user = create(:user)
      user.confirm
      user
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
          create(:message, room: room, user: owned_user, body: "オーナーからの返信")
          rooms << room
        end
      end
      rooms
    end

    let!(:another_owned_user) do
      user = create(:user)
      user.confirm
      user
    end

  let!(:another_owned_user_pet) { create(:pet, user: another_owned_user) }

  let!(:room_for_another_owned_user) do
    create(:room, user: owned_user, owner: another_owned_user, pet: another_owned_user_pet)
  end


    context 'joined_userがログインしている場合' do
      before do
        sign_in joined_users.first
        get :index
      end

      it 'ルーム一覧に遷移すること' do
        expect(request.fullpath).to eq('/rooms')
      end

      it 'ユーザーが参加しているルームを取得できること' do
        expect(assigns(:latest_messages).map(&:room).map(&:user_id).uniq).to include(joined_users.first.id)
      end
    end

    context 'owned_userがログインしている場合' do

      before do
        sign_in owned_user
        get :index
      end

      it 'ルーム一覧に遷移すること' do
        expect(request.fullpath).to eq('/rooms')
      end

      it 'ユーザーがオーナーであるルームを取得できること' do
        expect(assigns(:latest_messages).map(&:room).map(&:owner_id).uniq).to include(owned_user.id)
      end

      it '最新のメッセージを取得できること' do
        message_timestamps = assigns(:latest_messages).map(&:created_at)
        expect(message_timestamps).to eq(message_timestamps.sort.reverse)
    end




# TODO メッセージを作成日時の降順で取得する
    end
  end
end