# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  before_action :redirect_if_user_logged_in, only: [:new]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end

  def after_sign_in_path_for(_resource)
    admins_home_index_path
  end

  def after_sign_out_path_for(_resource)
    new_admin_session_path
  end

  private

  def redirect_if_user_logged_in
    return unless user_signed_in?

    flash[:alert] = 'すでにログインされています。'
    redirect_to users_path
  end
end
