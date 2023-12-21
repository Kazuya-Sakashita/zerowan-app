class HomeController < ApplicationController
  before_action :set_user_if_signed_in

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

  def set_user_if_signed_in
    @user = current_user if user_signed_in?
  end
end
