require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = create(:user)
    @user1 = create(:user)
  end

  describe 'ユーザー編集' do
    context '正常系' do
      it '登録情報編集画面が描画されていること' do
        get :edit, params: { id: @user.id }
        expect(response).to render_template 'users/edit'
      end

      it '正しく値が設定された場合ユーザーのマイページ画面が描画されること' do
        profile_params = attributes_for(:profile)
        put :update, params: { id: @user, user: { profile_attributes: profile_params } }
        expect(response).to redirect_to user_path
      end

      it '正しく値が設定された場合ユーザーの情報が更新されていること' do
        profile_params = attributes_for(:profile, avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/dog2.jpeg')),
                                                  name: 'riku',
                                                  address:'大阪市',
                                                  phone_number:'01234567810',
                                                  birthday:'2010-02-11',
                                                  breeding_experience:'犬猫３年',
                                                  user_id: @user.id)
        put :update, params: { id: @user, user: { profile_attributes: profile_params } }
        expect(@user.reload.profile.avatar.url).to include("dog2.jpeg")
        expect(@user.reload.profile.name).to eq 'riku'
        expect(@user.reload.profile.address).to eq '大阪市'
        expect(@user.reload.profile.phone_number).to eq '01234567810'
        expect(@user.reload.profile.birthday.strftime("%Y年%m月%d日")).to eq Date.strptime('2010-02-11').strftime("%Y年%m月%d日")
        expect(@user.reload.profile.breeding_experience).to eq '犬猫３年'
      end
    end
    context '異常系' do
      it '正しく値が設定されなかった場合、登録情報編集画面が描画されること' do
        profile_params = attributes_for(:profile, name: nil, user_id: @user.id)
        put :update, params: { id: @user, user: { profile_attributes: profile_params } }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'マイページ表示' do
    context '正常' do
      it 'マイページが描画されていること' do
        get :show, params: { id: @user.id }
        expect(response).to render_template 'users/show'
      end

      it '自分の投稿のみ表示（他ユーザーのペットは一覧に含まれないこと）' do
        5.times do
          @user_pets = create(:pet, user_id:@user.id)
        end

        3.times do
          @user1_pets = create(:pet, user_id:@user1.id)
        end

        get :show, params: { id: @user.id }
        expect(@user.pets.length).to eq 5
      end
    end
  end
end