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
    #空でavatar登録
    @profile_image = ProfileImage.create!(avatar: '', user_id: User.last.id)
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

  # GET /resource/edit
  def edit
    @user = User.find(params[:id])
    super
  end

  # PUT /resource
  def update
    if params[:user][:current_password].present?
      super
    else
      flash.now[:alert] = '変更する場合は現在のパスワードを入力してください。'
      render 'users/edit'
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
  def after_sign_up_path_for(resource)
    users_sign_up_complete_path
  end

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
