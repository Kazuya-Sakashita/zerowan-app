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

  def confirm
    @pet = Pet.new

    if @pet.valid?
      render action: 'confirm'
    else
      flash.now.alert = '入力に誤りがあります。'
      render action: 'new'
    end
  end

  def create
    @pet = Pet.new(pet_params.merge(user_id: current_user.id))
    binding.pry
    ActiveRecord::Base.transaction do
      @pet.save
      @pet.reload.id
      @pet_images = PetForm.new(pet_images_params)
      @pet_images.save!
    end

    flash[:notice] = "登録完了しました。"
    redirect_to pets_path
    #TODO showに遷移させようと思ったがidが渡せなかったので一旦、indexに遷移
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

  def pet_images_params
    params.require(:pet_form).permit(:id, { photos: [] }).merge(pet_id: @pet.id)
  end
end