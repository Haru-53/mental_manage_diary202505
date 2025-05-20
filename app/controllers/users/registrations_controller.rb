class Users::RegistrationsController < Devise::RegistrationsController
  # サインアップパラメータを許可
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  
  # createアクションを修正
  def create
    super do |resource|
      # 登録成功時の処理だけここに書く
      if resource.persisted?
        flash[:notice] = "アカウント登録が完了しました。ログインしてください。"
      end
    end
  end
  
  protected
  
  # サインアップ時のパラメータ設定
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
  
  # アカウント更新時のパラメータ設定
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
  
  # 新規登録後のリダイレクト先
  def after_sign_up_path_for(resource)
    new_user_session_path # 新規登録後はログインページへ
  end
  
  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    new_diary_entry_path # 日記作成ページへ
  end
  
  # アカウント更新後のリダイレクト先
  def after_update_path_for(resource)
    diaries_path # 日記一覧ページ
  end
end
