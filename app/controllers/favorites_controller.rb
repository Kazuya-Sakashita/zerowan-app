class FavoritesController < ApplicationController
  before_action :set_pet
  before_action :authenticate_user!
  def create
    @pet.favorites.create(user: current_user)
    redirect_to request.referer
  end

  def destroy
    @pet.favorites.find_by!(user: current_user).destroy
    redirect_to request.referer, status: :see_other
  end

  private
  def set_pet
    @pet = Pet.find(params[:pet_id])
  end
end
