# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters
  before_action :set_sign_up, only: %i[create confirm]

  # GET /resource/sign_up
  def new
    @user = User.new
    @user.build_profile
  end

  # POST /resource
  def create
    render :new and return if params[:back]

    super
  end

  # 新規追加
  def confirm
    if @user.valid?
      render action: 'confirm'
    else
      render action: 'new'
    end
  end

  # 新規追加
  def complete; end

  # アカウント登録後
  # def after_sign_up_path_for(resource)
  #   users_sign_up_complete_path(resource)
  # end

  # GET /resource/edit
  def edit
    @user = User.find(params[:id])
    super
  end

  # PUT /resource
  def update
    #super
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      # respond_with resource, location: after_update_path_for(resource)
      redirect_to edit_user_path(resource), notice: "アカウント情報更新しました。"
    else
      clean_up_passwords resource
      set_minimum_password_length
      binding.pry
      # respond_with resource
      redirect_to edit_user_path(resource), alert: "アカウント情報更新に失敗しました。"
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

  # def update_resource(resource, params)
  #   resource.update_without_password(params)
  # end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end

  private

  def set_sign_up
    @user = User.new(sign_up_params)
  end
end
