require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do

  #登録時のコントローラーのテスト
  # 全ての値があれば確認画面にいくことを評価

  let(:params) do
    {
      user: {
        email: "test123@test.com",
        password: "password",
        password_confirmation:"password",
          profile_attributes: {
            name: "山田太郎",
            address: "大阪市天王寺",
            phone_number: '0'*11,
            birthday: "2010-02-11",
            breeding_experience: "犬1年",
          }
      }
    }
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it '各パラメーターに正しく値が設定された場合、確認画面に遷移すること' do
    post :confirm, params: params
      expect(response).to be_successful
  end

  it '各パラメーターに値が正しく設定されなかった場合、登録画面を再描画し、バリデーションエラーが表示されること' do
    params[:user][:email] = nil
    post :confirm, params: params
    expect(response).to render_template "devise/registrations/new"

    # バリデーションエラーが表示されること
  end

  it '登録画面へのアクセスが成功すること' do
  get :new
  expect(response).to render_template "devise/registrations/new"
  end
end





