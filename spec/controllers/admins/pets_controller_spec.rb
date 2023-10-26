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
      expect(assigns(:pets)).to eq(Pet.all.page(1).per(20))
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

    context 'ユーザーが削除できなかった場合' do
      before do
        # Userモデルのdestroyメソッドがfalseを返すようにする
        allow_any_instance_of(Pet).to receive(:destroy).and_return(false)
      end

      it 'ユーザー一覧にリダイレクトし、正しいアラートが表示されること' do
        delete :destroy, params: { id: pet.id }
        expect(response).to redirect_to(admins_pets_path)
        expect(flash[:alert]).to eq('ペット削除に失敗しました。')
      end
    end
  end
end
