require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:params) do
    {
      user: {
        email: "kz0508+77@gmail.com",
        password: "password",
        password_confirmation: "password",
        profile_attributes: {
          name: "山田太郎",
          address: "大阪市天王寺",
          phone_number: '0' * 11,
          birthday: "2010-02-11",
          breeding_experience: "犬1年",
        }
      }
    }
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it '登録画面へのアクセスが成功すること' do
    get :new
    expect(response).to render_template "devise/registrations/new"
  end

  it '各パラメーターに正しく値が設定された場合、確認画面に遷移すること' do
    post :confirm, params: params
    expect(response).to be_successful
  end

  it '各パラメーターに値が正しく設定されなかった場合、登録画面を再描示されること' do
    params[:user][:email] = nil
    post :confirm, params: params
    expect(response).to render_template "devise/registrations/new"
  end

  it '各パラメーターに正しく値が設定された場合、home 画面が描画されること' do
    user = create(:user)
    sign_in user
    expect(response).to render_template "users/show"
  end

  it '各パラメーターに正しく値が設定された場合、ユーザーが正しく作成されること'

  it '各パラメーターに値が正しく設定されなかった場合、登録画面が描画されること'
  it 'params にユーザーの confirmation_token が正しく含まれていた場合、ログイン画面が描画されること'
  it 'flash メッセージが正しく表示されていること'
  it 'ユーザーが確認済み状態になっていること'
  it 'params にユーザーの confirmation_token が含まれていない場合、エラー画面が描画されること'
end





