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
    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    context '正常系' do
      it '正しく値が設定された場合、Home 画面が描画されること' do
        user_params = attributes_for(:user, email: user.email, password:'password',password_confirmation: 'password', current_password: 'password12345' )
        put :update, params: { user: user_params }
        expect(response).to redirect_to root_path
      end

      it '正しく値が設定された場合(パスワード)、flash メッセージが正しく表示されること' do
        user_params = attributes_for(:user, email: user.email, password:'password',password_confirmation: 'password', current_password: 'password12345' )
        put :update, params: { user: user_params }
        expect(flash[:notice]).to eq 'アカウント情報を変更しました。'
      end

      it '正しく値が設定された場合(パスワード)、ユーザーの情報が更新されていること' do
        user_params = attributes_for(:user, email: 'test123456789@test.com', password:'password',password_confirmation: 'password', current_password: 'password12345' )
        expect do
          put :update, params: { user: user_params }
        end.to change{user.reload.valid_password?("password")}
      end

      it '正しく値が設定された場合(メールアドレス)、flash メッセージが正しく表示されること' do
        user_params = attributes_for(:user, email: 'test9999999@test.com', current_password: user.password )
        put :update, params: { user: user_params }
        expect(flash[:notice]).to eq 'アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。'
      end

      it '正しく値が設定された場合(メールアドレス)、ユーザーの情報が更新されていること' do
        user_params = attributes_for(:user, email: 'test9999999@test.com', current_password: user.password )
        put :update, params: { user: user_params }
        user.reload.confirm
        expect(user.email).to eq 'test9999999@test.com'
      end
    end

    context '異常系' do
      it '正しく値が設定されなかった場合、登録情報編集画面が描画されること' do
        user_params = attributes_for(:user, email: user.email, current_password: nil )
        put :update, params: { user: user_params }
        expect(response).to render_template :edit
      end

      it '正しく値が設定されなかった場合、flash メッセージが正しく表示されること' do
        user_params = attributes_for(:user, email: user.email, current_password: nil )
        put :update, params: { user: user_params }
        expect(flash[:alert]).to eq '変更する場合は現在のパスワードを入力してください。'
      end
    end

  end
end