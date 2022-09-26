class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.all
  end

  def new
    # pet ペット情報を保存　petForm 画像を保存で分ける
    @pet = Pet.new
    @pet_images = PetForm.new

  end


  def create
    @pet = current_user.pets.build pet_params
    ActiveRecord::Base.transaction do
      @pet.save
      @pet.reload.id
      @pet_imagaes = PetForm.new(pet_id: @pet.id, pet_images: pet_images[:photos])
      @pet_imagaes.save!
    end

    flash[:notice] = "登録完了しました。"
    redirect_to pet_path @pet

  end

  def show
    @pets = Pet.find(params[:id])
  end

  def edit
  end

  private

  def pet_params
    params.require(:pet).permit(:category, :petname, :introduction, :gender, :age, :classification, :castration, :vaccination, :recruitment_status)
  end

  def pet_images
    params.require(:pet_form).permit(photos: [])
  end
end