class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Deviseのストロングパラメータ設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :name])
  end

  # ログイン後のリダイレクト先を明示的にトップページにする
  def after_sign_in_path_for(resource)
    root_path
  end

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end