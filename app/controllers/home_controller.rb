class HomeController < ApplicationController
  before_action :set_user_if_signed_in

  def index
    @pickups = Pet.joins(:pickup).order('pickup.created_at DESC')

    if params[:q].present?
      @q = Pet.ransack(search_params)
      @pets = @q.result(distinct: true)
                .eager_load(:pet_images, :pet_areas, :areas)
                .page(params[:page])
                .per(Settings.pagination.per.default)
    else
      params[:q] = { sorts: 'id asc' }
      @q = Pet.ransack(search_params)
      @pets = @q.result(distinct: true)
                .eager_load(:pet_images, :pet_areas, :areas)
                .page(params[:page])
                .per(Settings.pagination.per.default)
    end
  end

  def search
    index
    render :index
  end

  def set_user_if_signed_in
    @user = current_user if user_signed_in?
  end

  def search_params
    params.require(:q).permit(:category_eq, :gender_eq, :age_lteq, :classification_eq, :sorts, pet_areas_area_id_in: [])
  end
end
