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
    #TODO transaction途中でバリデーション判定できていない。保存できていないのに@pet.reload.idしている
    ActiveRecord::Base.transaction do
      @pet.save!
      @pet.reload.id
      @pet_imagaes = PetForm.new(pet_id: @pet.id, pet_images: pet_images[:photos])
      @pet_imagaes.save!
    end
    @pet.errors.full_messages
    flash[:notice] = "登録完了しました。"
    redirect_to pet_path @pet

  rescue => e
    flash[:alert] = "登録されませんでした。"
    render 'new'

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