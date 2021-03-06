class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                        profile_attributes: %i[
                                          name address phoneNumber birthday breedingExperience user_id
                                        ]
                                      ])
  end

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource)
    root_path # ログアウト後に遷移するpathを設定
  end
end
