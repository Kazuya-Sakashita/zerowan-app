class HomeController < ApplicationController
  def index
    @picked_up_pets = Pet.includes(:pet_images, :pet_areas).where(picked_up: true).order(created_at: :desc)

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
