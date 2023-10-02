require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = create(:user, &:confirm)
    sign_in @user
  end

  describe 'ユーザー編集' do
    context '正常系' do
      it '正しく値が設定された場合ユーザーのマイページ画面が描画されること' do
        profile_params = attributes_for(:profile)
        put :update, params: { user: { profile_attributes: profile_params } }
        expect(response).to redirect_to edit_users_path
      end

      it '正しく値が設定された場合ユーザーの情報が更新されていること' do
        profile_params = attributes_for(:profile, avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/dog2.jpeg')),
                                        name: 'riku',
                                        address: '大阪市',
                                        phone_number: '01234567810',
                                        birthday: '2010-02-11',
                                        breeding_experience: '犬猫３年',
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
      it '正しく値が設定されなかった場合、登録情報編集画面にリダイレクトされること' do
        profile_params = attributes_for(:profile, name: nil, user_id: @user.id)
        put :update, params: { id: @user, user: { profile_attributes: profile_params } }
        expect(response).to redirect_to edit_users_path
      end
    end
  end
end 