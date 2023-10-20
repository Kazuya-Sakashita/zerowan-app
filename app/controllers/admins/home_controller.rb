class Admins::HomeController < ApplicationController
  before_action :authenticate_admin!

  def index
    @user_registration_count = User.all.length
    @total_pets_for_adoption = Pet.all.length
  end
end
