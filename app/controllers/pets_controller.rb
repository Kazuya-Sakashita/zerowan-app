class PetsController < ApplicationController
  def index
    @pets = Pet.all
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    @pet.user_id = current_user.id
    if @pet.save!
      redirect_to pet_path(@pet)
    else
      render :new
    end

  end

  def show
  end

  def edit
  end
end

private
def pet_params
  params.permit(:category, :name, :introduction, :gender, :age, :classificationm, :vaccination, :recruitment_status, :user_id)
end
