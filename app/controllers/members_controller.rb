class MembersController < ApplicationController

  def index
    @user = User.find(params[:user_id])

    total_pets_count = @user.pets.count

    if params[:all]
      @pets = @user.pets.all
    else
      @pets = @user.pets.limit(4)
    end

    @show_more_link = total_pets_count > 4 && @pets.count < total_pets_count
  end
end
