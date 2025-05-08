Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # posts用のリソースルーティング
  resources :posts, only: [:index]

  # /up でアプリケーションのヘルスチェックを行う
  get "up" => "rails/health#show", as: :rails_health_check

  # 動的PWAファイルを提供する
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # ルートパスを設定
  root "posts#index"
end

