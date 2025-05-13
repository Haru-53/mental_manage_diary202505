Rails.application.routes.draw do
  # Deviseの認証関連ルーティング（1回のみ定義）
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # ログイン後のリダイレクト先
  authenticated :user do
    root 'diaries#index', as: :authenticated_root
  end


  # 未認証ユーザーのルートパス
  root 'posts#index'

  # ページ関連のルート
  get "pages/contact"
  get 'contact', to: 'pages#contact', as: 'contact'
  get 'announcements', to: 'pages#announcements', as: 'announcements'
  get "how_to_use", to: "pages#how_to_use"
  get "trial", to: "pages#trial"

  # 投稿関連のルート
  resources :posts do
    resources :comments, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end

  # 日記エントリー関連のルート
  resources :diary_entries do
    collection do
      get 'calendar'
      get 'search'
      get 'summary'
      get 'graph'
      get 'happiness_definition'
    end
  end

  # 日記関連のルート
  resources :diaries

  # タグ関連のルート
  resources :tags, only: [:index, :show]

  # プロフィール関連のルート
  resources :profiles, only: [:show, :edit, :update]

  # Rails ヘルスチェックとPWA関連
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
