Rails.application.routes.draw do
  # Devise 認証関連（1回のみ定義）
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # ログイン後のリダイレクト先
  authenticated :user do
    root 'diaries#index', as: :authenticated_root
  end

  # 未認証ユーザーのルート
  unauthenticated do
    root 'posts#index'
  end

  # ページ関連
  get 'contact', to: 'pages#contact', as: 'contact'
  get 'announcements', to: 'pages#announcements', as: 'announcements'
  get 'how_to_use', to: 'pages#how_to_use'
  get 'trial', to: 'pages#trial'

  # 投稿とコメント
  resources :posts do
    resources :comments, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end

  # 日記エントリー関連
  resources :diary_entries do
    collection do
      get 'calendar'
      get 'search'
      get 'summary'
      get 'graph'
      get 'happiness_definition'
    end
  end

  #幸福度定義ページ
  resources :happiness_items, only: [:index] do
    collection do
      patch :update_all
      patch :update_score
    end
  end

  # 日記（カレンダー含む）
  resources :diaries do
    collection do
      get :calendar
    end
  end

  # タグ
  resources :tags, only: [:index, :show]

  # プロフィール
  resources :profiles, only: [:show, :edit, :update]

  # Railsヘルスチェック / PWA関連
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
