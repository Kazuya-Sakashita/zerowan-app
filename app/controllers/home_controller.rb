class HomeController < ApplicationController
  def index
    @pickups = Pet.joins(:pickup).order('pickup.created_at DESC')

    if params[:q].present?
      @q = Pet.ransack(params[:q])
      @pets = @q.result(distinct: true).includes(:pet_images,
                                                 :pet_areas).page(params[:page]).per(Settings.pagination.per.default)
    else
      params[:q] = { sorts: 'id asc' }
      @q = Pet.ransack(params[:q])
      @pets = @q.result(distinct: true).page(params[:page]).per(Settings.pagination.per.default)
    end
  end

  def search
    index
    render :index
  end
end
