class Admins::HomeController < ApplicationController
  before_action :authenticate_admin!

  def index
    @user_registration_count = User.count
    @total_pets_for_adoption = Pet.count
  end
end
