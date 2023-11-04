require 'rails_helper'

RSpec.describe Admins::PetsController, type: :controller do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, &:confirm) }
  let!(:pet) { create(:pet, user:) }
  let!(:pets) { create_list(:pet, 21, user:) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it '全ユーザーを@usersとして割り当て、indexテンプレートをレンダリングすること' do
      get :index
      expect(assigns(:pets)).to eq(Pet.all.page(1).per(Settings.pagination.per.default))
      expect(response).to render_template(:index)
    end
  end

  describe 'DELETE #destroy' do
    context 'ペットが正常に削除された場合' do
      it 'ユーザー一覧にリダイレクトし、正しい通知が表示されること' do
        delete :destroy, params: { id: pet.id }
        expect(response).to redirect_to(admins_pets_path)
        expect(flash[:notice]).to eq('ペットが削除されました。')
      end
    end

    context 'ペットが削除できなかった場合' do
      before do
        # Petモデルのdestroyメソッドがfalseを返すようにする
        allow_any_instance_of(Pet).to receive(:destroy).and_return(false)
      end

      it 'ペット一覧にリダイレクトし、正しいアラートが表示されること' do
        delete :destroy, params: { id: pet.id }
        expect(response).to redirect_to(admins_pets_path)
        expect(flash[:alert]).to eq('ペット削除に失敗しました。')
      end
    end
  end

  describe 'GET #show' do
    context '指定されたユーザーの詳細を表示' do
      before { get :show, params: { id: pet.id } }

      it 'リクエストされたユーザーが@petに割り当てられていること' do
        expect(assigns(:pet)).to eq(pet)
      end

      it 'showテンプレートがレンダリングされていること' do
        expect(response).to render_template :show
      end
    end
  end
end
