module Members
  class PetsController < ApplicationController
    def index
      member = User.find(params[:member_id])
      @pets = member.pets.preload(:pet_images, :pet_areas, :areas, :user, :favorites, :rooms)
               .page(params[:page]).per(20)
    end
  end
end
