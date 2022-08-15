require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    get :show, params: { confirmation_token: user.confirmation_token }
  end

  describe 'show' do
    let!(:user) { create(:user) }
    context '正常系' do
      it 'params にユーザーの confirmation_token が正しく含まれていた場合、ログイン画面が描画されること' do
        # confirmation_tokenが正しく含まれていた場合はログイン画面遷移
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'flash メッセージが正しく表示されていること' do
        expect(flash[:notice]).to eq 'メールアドレスが確認できました。'
      end

      it 'ユーザーが確認済み状態になっていること' do
        user.reload
        # confirmed_atに日付が記録されている(nilじゃないこと)
        expect(:confirmed_at).not_to be_nil
      end
    end

    context '異常系' do
      it 'params にユーザーの confirmation_token が含まれていない場合、エラー画面が描画されること' do
        get :show, params: { confirmation_token: nil }
        # confirmation_tokenがない場合はnewへ遷移
        expect(response).to render_template :new
      end
    end
  end
end
