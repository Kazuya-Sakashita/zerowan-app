class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.all
  end

  def new
    @pet = Pet.new
    # @pet.pet_images.build
    @PetImages = @pet.pet_images.new

  end

  def create
    @pet = Pet.new(pet_params)
    # @pet.pet_images.build
    # @pet.user_id = current_user.id

    if @pet.save
      flash[:notice] = "登録完了しました。"
      redirect_to pet_path(@pet)
    else
      render :new, flash[:alert] = "登録できませんでした。"
    end
  end

  def show
    @pets = Pet.find(params[:id])
  end

  def edit
  end
end

private

def pet_params
  params.require(:pet).permit(:category, :petname, :introduction, :gender, :age, :classification, :castration, :vaccination, :recruitment_status,
                              pet_images_attributes: [:id, :photo])
end
