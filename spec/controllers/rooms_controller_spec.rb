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
        room = build(:room, user_id: user.id, owner_id: pet.user_id)

        allow(Pet).to receive(:find).and_return(pet)
        allow(pet.rooms).to receive(:find_or_initialize_by).and_return(room)
        allow(room).to receive(:persisted?).and_return(false)
        allow(room).to receive(:save).and_return(false)

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
    let(:owned_user) { create(:user, &:confirm) }

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
    end
  end

  describe 'GET #show' do

    let(:owned_user) { create(:user, &:confirm) }
    let(:joined_user) { create(:user, &:confirm) }
    let(:pet) { create(:pet, user_id: owned_user.id) }
    let(:room) { create(:room, user: joined_user, owner: owned_user, pet: pet) }

    before do
      sign_in joined_user
    end

    it 'リクエストされたroomを@roomにアサインする' do
      get :show, params: { id: room.id }
      expect(assigns(:room)).to eq room
    end

    it '関連するpetを@petにアサインする' do
      get :show, params: { id: room.id }
      expect(assigns(:pet)).to eq pet
    end

    it '@messageに新しいmessageをアサインする' do
      get :show, params: { id: room.id }
      expect(assigns(:message)).to be_a_new(Message)
    end

    it ':showテンプレートをレンダリングする' do
      get :show, params: { id: room.id }
      expect(response).to render_template :show
    end
  end
end