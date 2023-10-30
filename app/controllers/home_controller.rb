class HomeController < ApplicationController
  def index
    @picked_up_pets = PickedUpPet.includes(:pet).order(picked_up_at: :desc).to_a.map(&:pet)

    if params[:q].present?
      @q = Pet.ransack(params[:q])
      @pets = @q.result(distinct: true).includes(:pet_images, :pet_areas).page(params[:page]).per(20)
    else
      params[:q] = { sorts: 'id asc' }
      @q = Pet.ransack(params[:q])
      @pets = @q.result(distinct: true).page(params[:page]).per(20)
    end
  end

  def search
    index
    render :index
  end
end
