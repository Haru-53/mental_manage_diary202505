Rails.application.routes.draw do
  get "pages/contact"
  # ユーザー認証関連（Devise）
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # または独自認証システムの場合
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'sign_up', to: 'users#new'
  post 'sign_up', to: 'users#create'

  # 投稿関連
  resources :posts do
    resources :comments, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end

  # タグ関連
  resources :tags, only: [:index, :show]

  # プロフィール関連
  resources :profiles, only: [:show, :edit, :update]

  # アプリケーションのヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # 動的PWAファイルを提供する
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # ルートパス
  root "posts#index"
  # お問い合わせページへのルート
  get 'contact', to: 'pages#contact', as: 'contact'
  # お知らせページへのルート
  get 'announcements', to: 'pages#announcements', as: 'announcements'
end
