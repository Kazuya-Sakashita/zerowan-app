class MembersController < ApplicationController

  def show
    member = User.find(params[:id])
    @pets = Pet.preload(:pet_images, :pet_areas, :areas, :user, :favorites, :rooms).where(user_id:  member.id).limit(4)

    total_pets_count = member.pets.count
    @show_more_link = total_pets_count > 4 && @pets.count < total_pets_count
  end
end
