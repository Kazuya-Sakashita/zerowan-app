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

  #   context 'ペットの飼い主と閲覧ユーザー' do
  #     before do
  #       @pet_cust = create(:pet, user_id: user.id)
  #     end

  #     it '正しく設定された場合は、rooms/showに遷移すること' do
  #       get :show, params: { pet_id: @pet.id }
  #       expect(response).to render_template 'rooms/show'
  #     end

  #     it '正しく設定されなかった場合は、pet/showのままであること' do
  #       get :show, params: { pet_id: @pet_cust.id }
  #       expect(response).to redirect_to pet_path(@pet_cust)
  #     end
  #   end
  # end

end