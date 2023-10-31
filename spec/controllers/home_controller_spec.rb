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

    it '降順選択の場合、新着順であること' do
      get :search, params: { q: { sorts: 'id desc' } }
      expect(controller.instance_variable_get('@pets')[0]).to eq other_pet
      expect(controller.instance_variable_get('@pets')[1]).to eq pet
    end

    it '昇順選択の場合、登録順であること' do
      get :search, params: { q: { sorts: 'id asc' } }
      expect(controller.instance_variable_get('@pets')[0]).to eq pet
      expect(controller.instance_variable_get('@pets')[1]).to eq other_pet
    end

    it 'paramsがnilの場合、登録順であること' do
      get :search, params: nil
      expect(controller.instance_variable_get('@pets')[0]).to eq pet
      expect(controller.instance_variable_get('@pets')[1]).to eq other_pet
    end
  end

  describe 'ピックアップペットの取得' do
    let!(:pet1) { create(:pet) }
    let!(:pet2) { create(:pet) }
    let!(:unpicked_pet) { create(:pet) }
    let!(:picked_up_pet1) { create(:picked_up_pet, pet: pet1, created_at: 2.days.ago) }
    let!(:picked_up_pet2) { create(:picked_up_pet, pet: pet2, created_at: 1.day.ago) }

    before do
      get :index
    end

    it 'ピックアップ済みのペットを作成日の降順で取得すること' do
      expect(controller.instance_variable_get('@picked_up_pets')).to match_array([picked_up_pet2.pet,
                                                                                  picked_up_pet1.pet])
    end

    it 'ピックアップされていないペットは取得しないこと' do
      expect(controller.instance_variable_get('@picked_up_pets')).not_to include(unpicked_pet)
    end
  end
end
