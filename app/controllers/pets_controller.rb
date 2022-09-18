class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.all
  end

  def new
    # pet ペット情報を保存　petForm 画像を保存で分ける
    @pet = Pet.new
    @pet_imagaes = PetImage.new

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
    binding.pry
    @pet = Pet.new(pet_params.merge(user_id: current_user.id))
    binding.pry
    @pet_imagaes = PetImage.new(pet_images_params)
    binding.pry
    if @pet.save! && @pet_imagaes.save
      flash[:notice] = "登録完了しました。"
      redirect_to pets_path
      #TODO showに遷移させようと思ったがidが渡せなかったので一旦、indexに遷移
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
  params.require(:pet).permit(:category, :petname, :introduction, :gender, :age, :classification, :castration, :vaccination, :recruitment_status)

end
def pet_images_params
  params.require(:pet_image).permit(:id, { photos: [].to_s } )

end