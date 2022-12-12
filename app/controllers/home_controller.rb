class HomeController < ApplicationController
  def index
    @q = Pet.ransack(params[:q])
    @pets = @q.result(distinct: true).includes(:pet_images, :pet_areas).page(params[:page]).per(20)

  end

  def search
    index
    render :index
  end
end
