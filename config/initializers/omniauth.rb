Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :line, ENV['LINE_CLIENT_ID'], ENV['LINE_CLIENT_SECRET']
  provider :twitter2, ENV['TWITTER_CLIENT_ID'], ENV['TWITTER_CLIENT_SECRET']

  # CSRF保護を有効化
  configure do |config|
    config.request_validation_phase = OmniAuth::Strategies::OAuth2::RequestPhase
  end
end
