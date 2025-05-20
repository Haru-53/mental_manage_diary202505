Rails.application.routes.draw do
  # Deviseの認証関連ルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # ログイン済みユーザーのルート
  authenticated :user do
    root 'diaries#index', as: :authenticated_root
  end

  # 未ログインユーザーのルート
  unauthenticated do
    root 'posts#index'
  end

  # ページ関連
  get "pages/contact"
  get 'contact', to: 'pages#contact', as: 'contact'
  get 'announcements', to: 'pages#announcements', as: 'announcements'
  get "how_to_use", to: "pages#how_to_use"
  get "trial", to: "pages#trial"

  # 投稿
  resources :posts do
    resources :comments, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end

  # 日記エントリー
  resources :diary_entries, path: 'entries' do
    collection do
      get 'calendar'
      get 'search'
      get 'summary'
      get 'graph'
      get 'happiness_definition'
    end
  end

  # 日記
  resources :diaries

  # タグ
  resources :tags, only: [:index, :show]

  # プロフィール
  resources :profiles, only: [:show, :edit, :update]

  # PWA関連
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
