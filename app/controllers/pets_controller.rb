class PetsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    @pets = Pet.all
  end

  def new
    # pet ペット情報を保存　petForm 画像を保存で分ける
    @pet = Pet.new
    @pet_images = PetForm.new
    @pet_areas =  AreaForm.new
  end

  def create
    @pet = current_user.pets.build pet_params
    ActiveRecord::Base.transaction do
      @pet.save!
      @pet_imagaes = PetForm.new(pet_id: @pet.reload.id, pet_images: pet_images)
      @pet_areas =  AreaForm.new(pet_id: @pet.reload.id, pet_areas: pet_areas)
      @pet_imagaes.save!
      @pet_areas.save!

    end

    flash[:notice] = "登録完了しました。"
    redirect_to pet_path @pet

  rescue => e
    flash[:alert] = e.record.errors.full_messages
    redirect_to new_pet_path
  end

  def show
    @pet = Pet.find(params[:id])
    @pet_imagaes = @pet.pet_images
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
    if @pet.update(pet_params)
      flash[:notice] = "更新しました。"
      redirect_to @pet
    else
      flash[:alert] = "更新できませんでした。"
      render 'pets/edit'
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:category, :petname, :introduction, :gender, :age, :classification, :castration, :vaccination, :recruitment_status)
  end

  def pet_images
    params.dig(:pet_form, :photos) || []
  end

  def pet_areas
    params.dig(:area_form, :areas) || []
  end
end