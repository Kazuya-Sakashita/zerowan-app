module Members
  class PetsController < ApplicationController
    before_action :set_user, only: [:index]

    def index
      member = User.find(params[:member_id])
      @pets = member.pets.preload(:pet_images, :pet_areas, :areas, :user, :favorites, :rooms)
                    .page(params[:page]).per(20)
    end

    private

    def set_user
      @user = current_user
    end
  end

end
