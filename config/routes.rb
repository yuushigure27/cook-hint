Rails.application.routes.draw do



  # 顧客用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
    registrations: "user/registrations",
    sessions: 'user/sessions'
  }
  #ゲストログイン
  devise_scope :user do
    post "user/guest_sign_in", to: "user/sessions#guest_sign_in"
  end


  scope module: :user do
    root to: "homes#top"
    get 'about' => 'homes#about'
    get 'genre_search', to: 'searches#genre_search', as: :genre_search
    get "search" => "searches#search"


    # 投稿
    get 'posts/new', to: 'posts#new', as: 'new_post'
    post 'posts', to: 'posts#create'
    get 'posts' => 'posts#index'
    get 'posts/:id', to: 'posts#show', as: 'post'
    get 'posts/:id/edit', to: 'posts#edit', as: 'edit_post'
    delete 'posts/:id', to: 'posts#destroy', as: 'delete_post'

    resources :posts do
      resources :comments, only: [:create, :destroy, :edit, :update]
      resource :likes, only: [:create, :destroy]
    end

    resources :likes, only: [:index]

    # ジャンル
    resources :genres, only: [:index,:new,:create,:edit,:update,:destroy]

    # ユーザー
    get 'users' => 'users#index'
    get '/my_page', to: 'users#show', as: :my_page
    get 'users/unsubscribe' => 'users#unsubscribe'
    patch 'users/withdraw' => 'users#withdraw'
    get 'users/:id/edit' => 'users#edit', as: 'users_edit'
    patch 'users/:id' => 'users#update'



  end

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  devise_scope :admin do
    get 'admin', to: 'admin/sessions#new', as: :admin_session_new
  end

  namespace :admin do
    #root to: "sessions#new"
    resources :genres, only: [:index,:new,:create,:edit,:update,:destroy]
    resources :posts, only: [:index,:new,:create,:show,:edit,:update,:destroy]
    resources :users, only: [:index,:show,:edit,:update]

    get "search" => "searches#search"
    
    resources :posts do
      resources :comments, only: [:destroy]
    end
    
  end

end
