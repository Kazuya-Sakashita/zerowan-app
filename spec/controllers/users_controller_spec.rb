# require 'rails_helper'
#
# RSpec.describe UsersController, type: :controller do
#
#   #登録時のコントローラーのテスト
#   # 全ての値があれば確認画面にいくことを評価
#
#   before do
#     #userとprofileのparamsを作成
#     @profile_params = {
#       profiles_attributes: {
#         "0": attributes_for(:profile)
#       }
#     }
#     @params_nested = {
#       user: attributes_for(:user).merge( @profile_params )
#     }
#   end
#
#   it 各パラメーターに正しく値が設定された場合、確認画面に遷移すること do
#
#     post users_sign_up_confirm_url, prams: @params_nested
#     expect(response).to be_success
#   end
#
#
#   it 各パラメーターに値が正しく設定されなかった場合、登録画面を再描画し、バリデーションエラーが表示されること
#
# end