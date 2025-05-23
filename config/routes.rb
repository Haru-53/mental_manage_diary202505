Rails.application.routes.draw do
  # Devise 認証関連
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # ログイン済みユーザーのルート
  authenticated :user do
    root 'diary_entries#index', as: :authenticated_root
  end

  # 未ログインユーザーのルート
  unauthenticated do
    root 'posts#index'
  end

  # ページ関連
  get 'contact', to: 'pages#contact', as: 'contact'
  get 'announcements', to: 'pages#announcements', as: 'announcements'
  get 'how_to_use', to: 'pages#how_to_use'
  get 'trial', to: 'pages#trial'
  get 'try_app', to: 'pages#try_app', as: 'try_app'

  # 投稿とコメント
  resources :posts do
    resources :comments, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end

  # 日記エントリー関連
  resources :diary_entries, path: 'entries' do
    collection do
      get 'calendar'
      get 'search'
      get 'summary'
      get 'graph'
      get 'happiness_definition'
      get 'diary/search', to: 'diary_features#search', as: 'diary_search'
      get 'diary/happiness', to: 'diary_features#happiness', as: 'diary_happiness'
      get 'diary/summary', to: 'diary_features#summary', as: 'diary_summary'
    end
  end

  # 幸福度定義ページ
  resources :happiness_items, only: [:index] do
    collection do
      patch :update_all
      patch :update_score
    end
  end

  # Railsヘルスチェック / PWA関連
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
