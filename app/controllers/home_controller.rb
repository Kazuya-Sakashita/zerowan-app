class HomeController < ApplicationController
  def index
    @q = Pet.ransack(params[:q])
    @pets = @q.result.includes(:pet_images, :pet_areas)

  end

  def search
    index
    render :index
  end
end
