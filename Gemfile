source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.1"

# The original asset pipeline for Rails
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server
gem "puma", ">= 5.0"

# Use importmap for JavaScript modules
gem "importmap-rails"

# Hotwire's SPA-like page accelerator
gem "turbo-rails"

# Hotwire's modest JavaScript framework
gem "stimulus-rails"

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'bundle-audit', require: false
end

group :test do
  gem 'simplecov', require: false
  gem 'rspec_junit_formatter'
end

# Build JSON APIs with ease
gem "jbuilder"
gem 'sassc-rails'
# Windows does not include zoneinfo files
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching
gem "bootsnap", require: false

# SNSログイン機能
gem "devise"                         # ログイン、ログアウト、新規登録
gem "devise-i18n"                   # devise の日本語化
gem "omniauth"                      # OmniAuthの基本
gem "omniauth-rails_csrf_protection" # CSRF対策
gem "omniauth-google-oauth2"        # Google用
gem "dotenv-rails"                  # 環境変数管理

group :development, :test do
  # Debugging support
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  # Static analysis for security vulnerabilities
  gem "brakeman", require: false
  # Omakase Ruby styling
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages
  gem "web-console"
end

group :test do
  # Use system testing
  gem "capybara"
  gem "selenium-webdriver"
end

gem "tailwindcss-rails", "~> 4.2"
