Rails.application.routes.draw do
  root "pages#welcome"

  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: :get

  get "/logout" => "sessions#destroy", as: :logout

  get "/profile" => "users#show", as: :profile
  get "/u/:nickname" => "users#show", as: :user_details, constraints: { nickname: /[0-z\.-]+/ }
  get "/profile/edit" => "users#edit", as: :edit_profile
  patch "/profile/edit" => "users#update", as: :update_user
  get "/profile/change_identity/:identity_id" => "users#change_identity", as: :change_identity
  get "/students" => "users#index", as: :students
  post "/u/bulk_edit" => "users#bulk_edit", as: :bulk_edit_users
  post "/u/:nickname/comment" => "users#comment", as: :comment_user, constraints: { nickname: /[0-z\.-]+/ }

  resources :users, only: :destroy do
    member do
      post :toggle
      post :promote
      post :demote
    end
  end
  resources :teachers, only: [:index, :destroy]

  resources :badges, only: [:index, :show, :new, :create, :edit, :update]
  resources :occurrences, only: :destroy
  resources :events, only: [:index, :show, :new, :create, :edit, :update]
  resources :earnings, only: :destroy

  resources :competence_tags, except: :show

  resources :stats do
    collection do
      get :points
    end
  end

  resources :lectures, except: :destroy do
    collection do
      get :summary
    end
  end

  resources :exercises do
    get :start
  end

  resources :partners, only: :index

  resources :solutions do
    get :start
    get :summary
    patch :finish
    delete :cancel
    patch :add_partner
    resources :timers do
      post :play
      post :pause
    end
  end

  resources :repos, only: [:index, :new, :create]
  get "repos/:user/:name" => "repos#show", as: :repo, constraints: { user: /[0-z\.-]+/ }
  get "repos/:user/:name/grade" => "repos#grade", as: :grade, constraints: { user: /[0-z\.-]+/ }
  resources :test_runs, only: [:show]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :repos do
        match :pending, via: [:get], on: :collection
        match :grade, via: [:post], on: :member
      end
    end
  end

  resources :teams, except: :show

  get "/teams/:nickname" => "teams#show", as: :team_profile, constraints: { nickname: /[0-z\.-]+/ }
  # resources :articles, param: :slug
  # https://stackoverflow.com/a/31060067/2661448

  resources :courses, only: [:index] do
    member do
      post :enroll
      get :switch
    end
  end

  resources :dashboard, only: :index

  namespace :admin do
    resources :courses do
      member do
        get :toggle
        post :restore
      end
    end
    resources :users, only: [:index, :destroy, :edit, :update] do
      member do
        get :impersonate
        post :restore
      end
    end
  end

  resources :notifications, only: [:index, :new, :create]

  namespace :peer_review do
    resources :challenges do
      member do
        get :overview
        get :toggle
        post :publish
        post :unpublish
        get :purge
      end
      resources :solutions, only: [:new, :update, :show]
      resources :reviews, only: [:new, :update] do
        post :assess, on: :member
      end
    end
  end
end
