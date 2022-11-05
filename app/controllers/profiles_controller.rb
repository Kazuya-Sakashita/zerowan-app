class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[update]

  def update
    if @user.profile.avatar.present?
      params[:user][:profile_attributes][:avatar_cache] = @user.profile.avatar
    end

    if @user.update(user_params)
      flash[:notice] = "更新しました。"
      redirect_to users_path
    else
      flash[:alert] = "更新できませんでした。"
      render 'users/edit'
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
