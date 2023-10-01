module Members
  class PetsController < ApplicationController
    def index
      member = User.find(params[:member_id])
      @pets = Pet.preload(:pet_images, :pet_areas, :areas, :user, :favorites, :rooms)
               .where(user_id:  member.id)
               .page(params[:page]).per(20)
    end
  end
end
