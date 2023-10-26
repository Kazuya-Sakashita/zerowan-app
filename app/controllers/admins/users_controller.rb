class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: %i[show destroy]

  def index
    @users = User.includes(%i[profile pets]).page(params[:page]).per(20)
  end

  def show; end

  def destroy
    if @user.destroy
      redirect_to admins_users_path, notice: 'ユーザーが削除されました。'
    else
      redirect_to admins_users_path, alert: 'ユーザー削除に失敗しました。'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
