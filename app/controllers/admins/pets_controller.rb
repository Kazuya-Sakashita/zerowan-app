class Admins::PetsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_pet, only: %i[destroy show toggle_pickup]

  def index
    @pets = Pet.includes(user: :profile, pet_images: []).page(params[:page]).per(20)
  end

  def show; end

  def destroy
    if @pet.destroy
      redirect_to admins_pets_path, notice: 'ペットが削除されました。'
    else
      redirect_to admins_pets_path, alert: 'ペット削除に失敗しました。'
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  end
end
