require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'home画面' do
    it 'home画面が描画されていること' do
      get :index
      expect(response).to render_template '/'
    end
  end

  describe 'ソート機能' do
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
            category_eq: "",
            gender_eq: "",
            age_lteq: "",
            classification_eq: "",
            sorts: "id desc"
          }
      }
    end

    it '降順選択の場合、新着順であること' do
      get :search, params: params
      expect(controller.instance_variable_get("@pets")[0]).to eq other_pet
      expect(controller.instance_variable_get("@pets")[1]).to eq pet
    end

    it '昇順選択の場合、登録順であること' do
      params[:q] = { sorts: 'id asc' }
      get :search, params: params
      expect(controller.instance_variable_get("@pets")[0]).to eq pet
      expect(controller.instance_variable_get("@pets")[1]).to eq other_pet
    end

    it 'paramsがnilの場合、登録順であること' do
      get :search, params: nil
      expect(controller.instance_variable_get("@pets")[0]).to eq pet
      expect(controller.instance_variable_get("@pets")[1]).to eq other_pet
    end


  end
end