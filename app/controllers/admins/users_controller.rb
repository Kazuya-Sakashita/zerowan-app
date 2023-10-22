class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.includes(%i[profile pets]).page(params[:page]).per(20)
  end

  def show
    @user = User.includes(%i[profile pets]).find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admins_users_path, notice: 'ユーザーが削除されました。'
    else
      redirect_to admins_users_path, alert: 'ユーザー削除に失敗しました。'
    end
  end
end
