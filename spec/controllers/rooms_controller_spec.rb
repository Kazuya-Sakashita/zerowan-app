require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe '.new' do
    let!(:user) { create(:user, &:confirm) }
    let!(:another_user) { create(:user) }
    let!(:pet) { create(:pet, user_id: another_user.id) }

    before do
      sign_in user
    end

    context '自分自身のペットを選択した場合' do
      let!(:my_pet) { create(:pet, user_id: user.id) }

      before do
        get :new, params: { format: my_pet.id }
      end

      it 'エラーメッセージが表示される' do
        expect(flash[:error]).to eq('自分自身にメッセージはできません')
      end

      it '前のページにリダイレクトされる' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'Roomがまだ存在しない場合' do
      before do
        get :new, params: { format: pet.id }
      end

      it '新しいRoomが作成される' do
        room = Room.find_by(user_id: user.id, owner_id: another_user.id, pet_id: pet.id)
        expect(room).not_to be_nil
      end

      it '新しいRoomのページにリダイレクトする' do
        room = Room.find_by(user_id: user.id, owner_id: another_user.id, pet_id: pet.id)
        expect(response).to redirect_to(room_path(room))
      end
    end

    context '部屋の作成に失敗した場合' do
      before do
        allow_any_instance_of(Pet).to receive(:rooms).and_raise(StandardError)
        get :new, params: { format: pet.id }
      end

      it 'エラーメッセージが表示される' do
        expect(flash[:error]).to eq('問合せできませんでした。')
      end

      it '前のページにリダイレクトされる' do
        expect(response).to redirect_to(root_path)
      end
    end
  end


  describe '.index' do
    let(:owned_user) { create(:user, &:confirm) }
    let(:other_owned_user) { create(:user, &:confirm) }
    let(:joined_user) { create(:user, &:confirm) }
    let(:pet) { create(:pet, user_id: owned_user.id) }
    let!(:room_owned_by_user) { create(:room, owner: owned_user, user: joined_user, pet: pet) }
    let!(:room_user_belongs_to) { create(:room, owner: other_owned_user, user: owned_user, pet: pet) }
    let!(:other_room) { create(:room, owner: other_owned_user, user: joined_user, pet: pet) }

    before do
      sign_in owned_user
      get :index
    end

    it '正常にレスポンスを返すこと' do
      expect(response).to be_successful
    end

    context 'ログイン中のユーザーに関連していない部屋' do
      it '取得しないこと' do
        expect(assigns(:rooms)).not_to include(other_room)
      end
    end

    it '部屋を最新のメッセージの作成日時で並べること' do
      room1 = room_owned_by_user
      room2 = room_user_belongs_to
      create(:message, room: room1, user: joined_user, created_at: 1.day.ago)
      create(:message, room: room2, user: joined_user, created_at: 2.days.ago)
      expect(assigns(:rooms).first).to eq(room1)
      expect(assigns(:rooms).second).to eq(room2)
    end
  end

  describe '.show' do

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