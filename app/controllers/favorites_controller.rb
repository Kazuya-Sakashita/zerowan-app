class FavoritesController < ApplicationController
  def create
    Favorite.create(user_id: current_user.id, pet_id: params[:id])
    redirect_to pet_path(@pet.id)
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, pet_id: params[:id])
    favorite.destroy

    # TODO これは必要か不明、一旦記載しておく　「Rails 7.0 + Ruby 3.1でゼロからアプリを作ってみたときにハマったところあれこれ」
    respond_to do |format|
      format.html { redirect_to pet_path(@pet.id), status: :see_other }
    end
  end
end
