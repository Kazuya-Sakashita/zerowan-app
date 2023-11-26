class MembersController < ApplicationController
  before_action :set_user

  def show
    member = User.find(params[:id])
    @pets = Pet.preload(:pet_images, :pet_areas, :areas, :user, :favorites, :rooms).where(user_id: member.id).limit(4)

    @show_more_link = member.pets.offset(4).exists?
  end

  private

  def set_user
    @user = current_user
  end
end
