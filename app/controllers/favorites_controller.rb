class FavoritesController < ApplicationController
  def create
    @pet = Pet.find(params[:pet_id])
    Favorite.create(user_id: current_user.id, pet_id: @pet.id)
    redirect_to pet_path(@pet.id)
  end

  def destroy
    @pet = Pet.find(params[:pet_id])
    favorite = Favorite.find_by(user_id: current_user.id, pet_id: @pet.id)
    favorite.destroy
    redirect_to pet_path(@pet.id), status: :see_other
  end
end