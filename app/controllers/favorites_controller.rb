class FavoritesController < ApplicationController
  before_action :set_pet
  before_action :authenticate_user!

  def create
    @pet.favorites.create(user: current_user)

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.turbo_stream
    end
  end

  def destroy
    @pet.favorites.find_by!(user: current_user).destroy

    respond_to do |format|
      format.html { rredirect_to request.referer }
      format.turbo_stream
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end
end
