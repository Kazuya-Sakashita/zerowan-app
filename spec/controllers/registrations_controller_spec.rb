require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:params) do
    {
      user: {
        email: 'kz0508+77@gmail.com',
        password: 'password',
        password_confirmation: 'password',
        profile_attributes: {
          name: '山田太郎',
          address: '大阪市天王寺',
          phone_number: '0' * 11,
          birthday: '2010-02-11',
          breeding_experience: '犬1年'
        }
      }
    }
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'ユーザー登録' do
    context '正常系' do
      it '登録画面へのアクセスが成功すること' do
        get :new
        expect(response).to render_template 'devise/registrations/new'
      end

      it '各パラメーターに正しく値が設定された場合、確認画面に遷移すること' do
        post :confirm, params: params
        expect(response).to render_template 'devise/registrations/confirm'
      end

      it '各パラメーターに正しく値が設定された場合、ユーザーが正しく作成されること' do
        expect do
          post :create, params: params
        end.to change { User.count }.by(1)
      end

      it 'flash メッセージが正しく表示されていること' do
        post :create, params: params
        expect(flash[:notice]).to eq '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      end

      it '各パラメーターに正しく値が設定された場合、home 画面が描画されること' do
        post :confirm, params: params
        expect(response).to render_template '/'
      end

      it 'params に back: true が設定されている場合、登録画面が描画されること' do
        params[:back] = true
        post :create, params: params
        expect(response).to render_template 'devise/registrations/new'
      end
    end

    context '異常系' do
      it '各パラメーターに値が正しく設定されなかった場合、登録画面を再描示されること' do
        params[:user][:email] = nil
        post :create, params: params
        expect(response).to render_template 'devise/registrations/new'
      end
    end
  end

  describe 'ユーザー更新' do

    context '正常系' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        @user = create(:user)
        @user.confirm
      end

      it '正しく値が設定された場合、Home 画面が描画されること' do
        binding.pry
        sign_in @user
        user_params = attributes_for(:user, password:'password',password_confirmation: 'password', current_password:@user.password )
        patch :update, params: { id: @user, user: user_params }

        expect(response).to redirect_to root_path
        # TODO ここからスタート
      end

      '正しく値が設定された場合、flash メッセージが正しく表示されること'
      '正しく値が設定された場合、ユーザーの情報が更新されていること'
    end

    context '異常系' do
      '正しく値が設定されなかった場合、登録情報編集画面が描画されること'
      '正しく値が設定されなかった場合、flash メッセージが正しく表示されること'
    end

  end
end