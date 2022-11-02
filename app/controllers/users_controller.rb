class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
    @user_pets = @user.pets
  end

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
    params.require(:user).permit(profile_attributes: %i[id name address phone_number birthday breeding_experience avatar avatar_cache])
  end

  def set_user
    @user = current_user
  end
end
