require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe '#index' do
    let(:owned_user) { create(:user, &:confirm) }
    let!(:pets) { create_list(:pet, 5, user: owned_user) }

    before do
      sign_in owned_user
      allow(controller).to receive(:params).and_return(params)
    end

    context '全てのペットを取得する場合' do
      let(:params) { { user_id: owned_user.id, all: 'true' } }

      before do
        get :index
      end

      it '正常にレスポンスを返すこと' do
        expect(response).to be_successful
      end

      it '全てのペットを@petsに格納する' do
        expect(assigns(:pets).count).to eq 5
      end

      it '@show_more_linkはfalseである' do
        expect(assigns(:show_more_link)).to be false
      end
    end

    context 'ペットを4つまで取得する場合' do
      let(:params) { { user_id: owned_user.id } }

      it '@petsには4つのペットが格納される' do
        get :index
        expect(assigns(:pets).count).to eq 4
      end

      it '@show_more_linkはtrueである' do
        get :index
        expect(assigns(:show_more_link)).to be true
      end
    end
  end
end