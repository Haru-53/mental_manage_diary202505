class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name])
  end

    # ログイン後のリダイレクト先を設定
    def after_sign_in_path_for(resource)
      diary_entries_path# 日記一覧ページへ遷移（パスは実際のルーティングに合わせて変更）
      # または edit_diary_path(@diary) など特定の日記編集ページへ
    end
  
    # ログアウト後のリダイレクト先を設定
    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path # ログアウト後はログインページへ
    end

      protected
  
  # Deviseのストロングパラメータ設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

end
