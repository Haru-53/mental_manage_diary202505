# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  # サインアップパラメータを許可
  before_action :configure_sign_up_params, only: [:create]

  protected
  def after_sign_up_path_for(resource)
    new_user_session_path  # ログインページへ
  end
  # サインアップ時のパラメータ設定
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def create
    super
  end

  # リソース作成時のカスタム処理
  def create
    build_resource(sign_up_params)

    if resource.save
      # 自動確認が必要な場合
      if resource.respond_to?(:confirmed_at)
        resource.confirmed_at = Time.current if resource.confirmation_required?
        resource.save
      end

      # サインアップ後のリダイレクト
      set_flash_message! :notice, :signed_up
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # 新規登録後のリダイレクト先を設定
  def after_sign_up_path_for(resource)
    new_user_session_path # 新規登録後はログインページへ
  end

  # アカウント更新後のリダイレクト先
  def after_update_path_for(resource)
    diaries_path # 日記一覧ページなど
  end

  # アカウント更新時のパラメータ設定
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  # プライベートメソッド
  private

  # サインアップ時に許可するパラメータ
  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  # アカウント更新時に許可するパラメータ
  def account_update_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password)
  end
end
