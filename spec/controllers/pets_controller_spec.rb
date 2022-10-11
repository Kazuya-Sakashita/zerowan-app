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
        @pet = create(:pet,user_id: user.id)
        pet_images = Array.new
        pet_images << fixture_file_upload('spec/fixtures/images/Dachshund3.jpeg', 'image/jpeg')
        pet_images << fixture_file_upload('spec/fixtures/images/dog2.jpeg', 'image/jpeg')

        @pet_images = PetForm.new(pet_id: @pet.id, pet_images: pet_images)
        binding.pry
        @pet_images.save
        binding.pry
        expect(response).to redirect_to pet_path @pet

      end

      '登録時、各パラメータに正しく値が設定された場合、Petが正しく作成されていること'
      '各パラメータに正しく値が設定された場合、flash画面が正しく表示されていること'
      '登録時、各パラメータに正しく値が設定されなかった場合、登録画面が描画されること'
      '各パラメータに正しく値が設定されていなかあった場合、flash画面が正しく表示されていること'
      '登録時、params に back: true が設定されている場合、登録画面が描画されること'

    end

  end
end