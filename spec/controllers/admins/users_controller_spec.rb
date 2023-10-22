require 'rails_helper'

RSpec.describe Admins::UsersController, type: :controller do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, &:confirm) }
  let!(:users) do
    create_list(:user, 20, &:confirm)
  end
  let!(:pets) do
    create_list(:pet, 5, user:)
  end

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it '全ユーザーを@usersとして割り当て、indexテンプレートをレンダリングすること' do
      get :index
      expect(assigns(:users)).to eq(User.all.page(1).per(20))
      expect(response).to render_template(:index)
    end
  end

  describe 'DELETE #destroy' do
    context 'ユーザーが正常に削除された場合' do
      it 'ユーザー一覧にリダイレクトし、正しい通知が表示されること' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(admins_users_path)
        expect(flash[:notice]).to eq('ユーザーが削除されました。')
      end
    end

    context 'ユーザーが削除できなかった場合' do
      before do
        # Userモデルのdestroyメソッドがfalseを返すようにする
        allow_any_instance_of(User).to receive(:destroy).and_return(false)
      end

      it 'ユーザー一覧にリダイレクトし、正しいアラートが表示されること' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(admins_users_path)
        expect(flash[:alert]).to eq('ユーザー削除に失敗しました。')
      end
    end
  end
end
