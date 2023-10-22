class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.page(params[:page]).per(20)
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice: 'ユーザーが削除されました。'
    else
      redirect_to admin_users_path, alert: 'ユーザー削除に失敗しました。'
    end
  end
end
