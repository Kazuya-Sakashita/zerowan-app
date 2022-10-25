class UsersController < ApplicationController
  before_action :find_user, only: %i[show edit update]

  def show; end

  def edit; end

  def update
    if @user.profile.avatar.present?
      params[:user][:profile_attributes][:avatar_cache] = @user.profile.avatar
    end

    if @user.update(user_params)
      redirect_to @user
    else
      flash[:alert] = "更新できませんでした。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(profile_attributes: %i[name address phone_number birthday breeding_experience avatar avatar_cache])
  end

  def find_user
    @user = User.find(params[:id])
  end
end
