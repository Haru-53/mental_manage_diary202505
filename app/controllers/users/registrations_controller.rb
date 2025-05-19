class Users::RegistrationsController < Devise::RegistrationsController
  # サインアップパラメータを許可
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  
  # createアクションを完全に書き換え
  def create
    build_resource(sign_up_params)
    
    # 保存処理
    resource.save
    
    # 保存の成否によって処理を分岐
    if resource.persisted?
      # フラッシュメッセージを設定
      set_flash_message! :notice, :signed_up
      
      # ログインせずにログインページへリダイレクト
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      # 登録失敗時の処理
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end

     super do |resource|
      # ここでflashメッセージをクリアすると、Deviseのデフォルトメッセージが表示されなくなる
      # ただしこの場合は、カスタムメッセージを設定する必要がある
  
      flash[:notice] = "ログインしました。"
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