class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.all
  end

  def new
    @pet = PetForm.new(user_id: current_user.id)

  end

  def create
    @pet = PetForm.new(pet_form_params.merge(user_id: current_user.id))
    if @pet.save!
      flash[:notice] = "登録完了しました。"
      redirect_to pets_path
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

def pet_form_params
  params.require(:pet_form).permit(:category, :petname, :introduction, :gender, :age, :classification, :castration, :vaccination, :recruitment_status, photoes: [])
end