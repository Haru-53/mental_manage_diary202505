Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :line, ENV['LINE_CLIENT_ID'], ENV['LINE_CLIENT_SECRET']
  # provider :twitter2, ENV['TWITTER_CLIENT_ID'], ENV['TWITTER_CLIENT_SECRET']
end

# 基本的な設定のみ
OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true