class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit]

  def show
    @user_pets = @user.pets
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit(profile_attributes: %i[id name address phone_number birthday breeding_experience avatar avatar_cache])
  end

  def set_user
    @user = current_user
  end
end
