class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.includes(:user)
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def edit
  end

  def new
    @pet = Pet.new
    @pet.pet_images.build

  end

  def confirm
    # if @pet.valid?
      render action: 'confirm'
  #   else
  #     render action: 'new'
  #   end
  end

  def create
    @pet = current_user.pets.create(pet_params)
    if @pet.save!
      redirect_to pets_path
    else
      render new
    end
  end

  def pet_params
    params.require(:pet).permit(:category, :name, :introduction, :gender, :age, :classification, :castration, :vaccination, :recruitment_status, :user_id,
                                pet_images_attributes: [:pet_id, :image])
  end
end