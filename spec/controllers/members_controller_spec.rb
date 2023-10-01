require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe '#show' do
    describe '@show_more_linkがtrueの場合' do
      let(:owned_user) { create(:user, &:confirm) }
      let!(:pets) { create_list(:pet, 5, user: owned_user) }

      before do
        sign_in owned_user
      end

      context '全てのペットを取得する場合' do
        before do
          get :show, params: { id: owned_user.id }
        end

        it '正常にレスポンスを返すこと' do
          expect(response).to be_successful
        end
      end

      context 'ペットを4つまで取得する場合' do
        before do
          get :show, params: { id: owned_user.id }
        end

        it '@petsには4つのペットが格納される' do
          expect(assigns(:pets).count).to eq 4
        end

        it '@show_more_linkはtrueである' do
          expect(assigns(:show_more_link)).to be true
        end
      end
    end

    describe '@show_more_linkがfalse(ペットが3つ)の場合' do
      let(:owned_user) { create(:user, &:confirm) }
      let!(:pets) { create_list(:pet, 3, user: owned_user) }

      before do
        sign_in owned_user
      end

      context 'ペットを3つまで取得する場合' do
        before do
          get :show, params: { id: owned_user.id }
        end

        it '@petsには3つのペットが格納される' do
          expect(assigns(:pets).count).to eq 3
        end

        it '@show_more_linkはfalseである' do
          expect(assigns(:show_more_link)).to be false
        end
      end
    end
  end
end
