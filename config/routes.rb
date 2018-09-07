Rails.application.routes.draw do
  root "pages#welcome"

  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  get "/logout" => "sessions#destroy", as: :logout

  get "/profile" => "users#show", as: :profile
  get "/u/:nickname" => "users#show", as: :user_details, constraints: { nickname: /[0-z\.-]+/ }
  get "/profile/edit" => "users#edit", as: :edit_profile
  patch "/profile/edit" => "users#update", as: :update_user
  get "/profile/change_identity/:identity_id" => "users#change_identity", as: :change_identity
  get "/u/:nickname/impersonate" => "users#impersonate", as: :impersonate_user, constraints: { nickname: /[0-z\.-]+/ }
  get "/u/:nickname/disable" => "users#disable", as: :disable_user, constraints: { nickname: /[0-z\.-]+/ }
  get "/students" => "users#index", as: :students
  get "/guests" => "users#guests", as: :guests
  post "/u/bulk_edit" => "users#bulk_edit", as: :bulk_edit_users
  post "/u/:nickname/comment" => "users#comment", as: :comment_user, constraints: { nickname: /[0-z\.-]+/ }

  get "/events/" => "events#index", as: :events_list
  get "/events/new" => "events#new", as: :new_event
  post "/events/new" => "events#create", as: :create_event
  get "/events/:event_id/show" => "events#show", as: :event_details
  get "/events/:event_id/register/:nickname" => "events#register", as: :register_event, constraints: { nickname: /[0-z\.-]+/ }

  get "/badges/" => "badges#index", as: :badges_list
  get "/badges/new" => "badges#new", as: :new_badge
  post "/badges/new" => "badges#create", as: :create_badge
  get "/badges/:badge_id/show" => "badges#show", as: :badge_details
  get "/badges/:badge_id/register/:nickname" => "badges#register", as: :register_badge, constraints: { nickname: /[0-z\.-]+/ }

  resources :lectures, only: [:index, :new, :create, :show] do
    member do
      post :register
      post :quick_register
    end
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

  resources :teams, except: :show do
    patch :add_member
  end

  get "/teams/:nickname" => "teams#show", as: :team_profile, constraints: { nickname: /[0-z\.-]+/ }
  # resources :articles, param: :slug
  # https://stackoverflow.com/a/31060067/2661448

  resources :courses, only: [:index] do
    member do
      get :enroll
      get :switch
    end
  end

  resources :notifications, only: [:index, :new, :create]

  namespace :peer_review do
    resources :challenges, only: [:index, :new, :create, :show] do
      member do
        get :overview
        get :toggle
      end
      resources :solutions, only: [:new, :update, :show]
      resources :reviews, only: [:new, :update]
    end
  end
end
