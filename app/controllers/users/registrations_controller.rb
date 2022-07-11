# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters

  # GET /resource/sign_up
  def new
    @user = User.new
    @user.build_profile
    
  end

  # POST /resource
  def create
    @user = User.new(sign_up_params)
    render :new and return if params[:back]
    super
  end

    # 新規追加
  def confirm
    @user = User.new(sign_up_params)
    # @profile = @user.build_profile(@user.profile)
    if @user.valid?
      render :action => 'confirm'
    else
     render :action => 'new'
    end
  end

    # 新規追加
  def complete
  end


  # アカウント登録後
  # def after_sign_up_path_for(resource)
  #   users_sign_up_complete_path(resource)
  # end



  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def account_update_params
    params.permit(:name, :email,profile_attributes: [:name,:address, :phoneNumber, :birthday, :breedingExperience, :user_id ])
  end
end
