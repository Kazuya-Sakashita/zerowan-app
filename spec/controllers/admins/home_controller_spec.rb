require 'rails_helper'

RSpec.describe Admins::HomeController, type: :controller do
  let(:admin) { create(:admin) } # FactoryでAdminモデルのインスタンスを作成します。

  before do
    sign_in admin # Deviseのヘルパーメソッドを使用して、adminをログインさせます。
  end

  describe 'GET #index' do
    let!(:joined_users) do
      users = create_list(:user, 10)
      users.each(&:confirm)
      users
    end

    let!(:pets) do
      create_list(:pet, 5, user: joined_users.first)
    end

    before do
      get :index
    end

    it '正しいユーザー登録数を割り当てること' do
      expect(assigns(:user_registration_count)).to eq(10)
    end

    it '正しい里親募集数を割り当てること' do
      expect(assigns(:total_pets_for_adoption)).to eq(5)
    end

    it 'indexテンプレートを正しくレンダリングすること' do
      expect(response).to render_template(:index)
    end
  end
end