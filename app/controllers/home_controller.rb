class HomeController < ApplicationController
  def index
    if params[:q].present?
      @q = Pet.ransack(params[:q])
      @q.build_sort if @q.sorts.empty?
      @pets = @q.result(distinct: true).includes(:pet_images, :pet_areas).page(params[:page]).per(20)
    else
      params[:q] = { sorts: 'id desc' }
      @q = Pet.ransack()
      @pets = Pet.all.page(params[:page]).per(20)
    end
  end

  def search
    index
    render :index
  end
end
