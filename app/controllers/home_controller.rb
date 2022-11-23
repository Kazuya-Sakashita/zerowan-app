class HomeController < ApplicationController
  def index
    @q = Pet.ransack(params[:q])
    @pets = @q.result.includes(:pet_images, :pet_areas)
    # TODO エリアの指定の部分がわからなかったので、下記を追記した。
    if params[:areas].present?
      @pets = @pets.where(area_id: params[:areas])
    end
  end

  def search
    index
    render :index
  end
end
