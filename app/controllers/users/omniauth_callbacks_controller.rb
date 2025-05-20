class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Google認証のコールバック
  def google
    handle_oauth("Google")
  end

  # X(Twitter)認証のコールバック
  def twitter
    handle_oauth("X")
  end

  # LINE認証のコールバック
  def line
    handle_oauth("LINE")
  end

  # 認証失敗時
  def failure
    redirect_to root_path, alert: "認証に失敗しました。もう一度試してください。"
  end

  private

  def handle_oauth(provider_name)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      session["devise.#{provider_name.downcase}_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: "#{provider_name}でのユーザー登録に失敗しました。"
    end
  end
end
