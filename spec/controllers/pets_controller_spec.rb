require 'rails_helper'

RSpec.describe PetsController, type: :controller do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '里親募集登録' do
    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    context '正常系' do
      it '登録画面が描画されること' do
        get :new
        expect(response).to render_template 'pets/new'
      end

      it '登録時、各パラメータに正しく値が設定された場合、SHOW画面が描画されること' do
        # pet_params = attributes_for(:pet,
        #                             category: 'dog',
        #                             petname: 'Riku',
        #                             introduction: '優しく、賢い',
        #                             gender: 'male',
        #                             age: 12,
        #                             classification: 'Chihuahua',
        #                             castration: 'neutered',
        #                             vaccination: 'vaccinated',
        #                             recruitment_status: 0,
        #                             user_id: user.reload.id
        # )
        # pet_images = attributes_for(:pet_image,
        #
        #
        # pet_params = attributes_for(:pet_form,
        #                             photo
        #
        # put :create, params: { pet: pet_params }
        # expect(flash[:notice]).to eq '登録完了しました。'
      end



      '登録時、各パラメータに正しく値が設定された場合、Petが正しく作成されていること'
      '各パラメータに正しく値が設定された場合、flash画面が正しく表示されていること'
      '登録時、各パラメータに正しく値が設定されなかった場合、登録画面が描画されること'
      '各パラメータに正しく値が設定されていなかあった場合、flash画面が正しく表示されていること'
      '登録時、params に back: true が設定されている場合、登録画面が描画されること'

    end

  end
end
