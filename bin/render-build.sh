#!/usr/bin/env bash
set -o errexit

# Rubyの依存をインストール
bundle install

# Node.jsの依存が必要なら（package.jsonがあるなら）
# yarn install

# アセットのプリコンパイルとDBマイグレーション
bundle exec rails assets:precompile
bundle exec rails db:migrate
