# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # サインアップ処理
  def create
    build_resource(sign_up_params)

    if resource.save
      # 確認メールが必要な場合に即時確認
      if resource.respond_to?(:confirmed_at) && resource.confirmation_required?
        resource.confirmed_at = Time.current
        resource.save
      end

      flash[:notice] = "アカウント登録が完了しました。ログインしてください。"
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  # SNS連携ユーザーはパスワードなしで更新可能
  def update_resource(resource, params)
    if resource.provider.present?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      super
    end
  end

  # サインアップ時の追加パラメータ許可
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  # アカウント更新時の追加パラメータ許可
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :image])
  end

  # 新規登録後のリダイレクト先（ログイン画面へ）
  def after_sign_up_path_for(resource)
    new_user_session_path
  end

  # ログイン後のリダイレクト先（日記作成ページへ）
  def after_sign_in_path_for(resource)
    new_diary_entry_path
  end

  # アカウント更新後のリダイレクト先（日記一覧ページへ）
  def after_update_path_for(resource)
    diaries_path
  end

  private

  # Strong Parameters：サインアップ用
  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  # Strong Parameters：アカウント更新用
  def account_update_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password, :image)
  end
end
