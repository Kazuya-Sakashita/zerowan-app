require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'home画面' do
    it 'home画面が描画されていること' do
      get :index
      expect(response).to render_template '/'
    end
  end

  describe 'home画面' do
    let!(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
    end

    let!(:pet) do
      create(:pet)
    end

    let!(:other_pet) do
      create(:pet)
    end

    let!(:params) do
      {
        q:
      {
        category_eq:  "0",
        gender_eq:  "",
        age_lteq:  "",
        classification_eq:  "",
        sorts: "id asc"
      }
      }
    end

    it '登録順に表示されること' do
      get :index
      binding.pry

      # TODO @petsの中身を確認する
    end

    it '新着順に表示されること' do
      get :index, params: params
      binding.pry

      # TODO @petsの中身を確認する
    end

  end
end