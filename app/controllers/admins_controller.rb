class AdminsController < ApplicationController
  before_action :authenticate_admin!
  def show
    @user_registration_count = User.all.length
    @total_pets_for_adoption = Pet.all.length
  end
end
