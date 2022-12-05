class HomeController < ApplicationController
  def index
    @q = Pet.ransack(params[:q])
    @pets = @q.result(distinct: true).includes(:pet_images, :pet_areas).page(params[:page]).per(6)

  end

  def search
    index
    render :index
  end
end
