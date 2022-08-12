require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]

  end

  it 'params にユーザーの confirmation_token が含まれていない場合、エラー画面が描画されること' do
    create(:user)
    user = User.last
    token = user.confirmation_token
    get :show, params: {confirmation_token: nil}
    #confirmation_tokenがない場合はnewへ遷移
    expect(response).to render_template :new
    #warn_about_bare_errorが発生している
    # TODO 書き方調べる
  end

  it 'params にユーザーの confirmation_token が正しく含まれていた場合、ログイン画面が描画されること' do
    create(:user)
    user = User.last
    token = user.confirmation_token
    get :show, params: {confirmation_token: token}
    #confirmation_tokenが正しく含まれていた場合はnログイン画面遷移
    expect(response).to redirect_to "/users/sign_in"
  end

end