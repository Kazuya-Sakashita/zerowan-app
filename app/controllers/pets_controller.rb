class PetsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_user
  before_action :set_pet, only: %i[show edit update update_status]

  def index; end

  def new
    # pet ペット情報を保存　petForm 画像を保存で分ける
    @pet = Pet.new
    @pet_images = PetForm.new
    @pet_areas =  AreaForm.new
  end

  def create
    @pet = current_user.pets.build(pet_params)
    ActiveRecord::Base.transaction do
      @pet.save!
      @pet_images = PetForm.new(pet_id: @pet.reload.id, pet_images:)
      @pet_areas =  AreaForm.new(pet_id: @pet.reload.id, pet_areas:)
      @pet_images.save!
      @pet_areas.save!
    end

    flash[:notice] = '登録完了しました。'
    redirect_to pet_path @pet
  rescue StandardError => e
    flash[:alert] = e.record.errors.full_messages
    redirect_to new_pet_path
  end

  def show
    @pet_images = @pet.pet_images
    @pet_areas = @pet.pet_areas
  end

  def edit
    @pet_images = PetForm.new
    @pet_areas =  AreaForm.new
    @pet_set_areas = @pet.pet_areas.pluck(:area_id)
  end

  def update
    ActiveRecord::Base.transaction do
      @pet.update!(pet_params)
      if pet_images.present?
        @pet.pet_images.destroy_all
        @pet_images = PetForm.new(pet_id: @pet.id, pet_images:)
        @pet_images.save!
      end
      if pet_areas.present?
        @pet.pet_areas.destroy_all
        @pet_areas = AreaForm.new(pet_id: @pet.id, pet_areas:)
        @pet_areas.save!
      end
    end

    flash[:notice] = '登録完了しました。'
    redirect_to pet_path @pet
  rescue StandardError => e
    flash[:alert] = e.record.errors.full_messages
    redirect_to edit_pet_path
  end

  def update_status
    if @pet.update(recruitment_status: params[:pet][:recruitment_status])
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @pet, notice: 'ステータスが更新されました。' }
      end
    else
      # エラーがあった場合の処理
      redirect_to @pet, alert: 'ステータスの更新に失敗しました。'
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:category, :petname, :introduction, :gender, :age, :classification, :castration,
                                :vaccination, :recruitment_status)
  end

  def pet_images
    params.dig(:pet_form, :photos) || []
  end

  def pet_areas
    params.dig(:area_form, :areas) || []
  end

  def set_user
    @user = current_user
  end

  def set_pet
    @pet = Pet.find(params[:id])
  end
end
