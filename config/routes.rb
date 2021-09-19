Rails.application.routes.draw do
  root "pages#root"

  def publishable
    post :publish, on: :member
    post :unpublish, on: :member
  end

  def discardable
    post :restore, on: :member
    get :bin, on: :collection
  end

  def votable
    post :upvote, on: :member
    post :downvote, on: :member
    post :unvote, on: :member
  end

  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: :get

  get "/logout" => "sessions#destroy", as: :logout
  post "/admin_login" => "sessions#admin", as: :admin_login

  get "/welcome" => "pages#welcome", as: :welcome
  get "/profile" => "users#show", as: :profile
  get "/u/:nickname" => "users#show", as: :user_details, constraints: { nickname: /[0-z.-]+/ }
  get "/profile/edit" => "users#edit", as: :edit_profile
  patch "/profile/edit" => "users#update", as: :update_user
  get "/profile/change_identity/:identity_id" => "users#change_identity", as: :change_identity

  resources :students, only: [:index, :edit, :update, :destroy] do
    member do
      post :toggle
      post :promote
      post :comment
    end
    collection do
      post :bulk_edit
    end
  end

  resources :teachers, only: :index
  resources :teams, except: :show

  resources :suggestions, except: [:edit, :update] do
    get :dismissed, on: :collection
    post :restore, on: :member
    post :mark_as_done, on: :member
    votable
  end

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

  get "/teams/:nickname" => "teams#show", as: :team_profile, constraints: { nickname: /[0-z.-]+/ }
  # resources :articles, param: :slug
  # https://stackoverflow.com/a/31060067/2661448

  resources :courses, only: [:index] do
    member do
      post :enroll
      get :switch
    end
    collection do
      get :current
    end
  end

  resources :resource_categories, except: [:show]
  resources :resources, except: [:show] do
    publishable
    votable
  end

  resources :faqs, except: [:show]

  resources :dashboard, only: :index
  resources :posts, only: [:create, :destroy] do
    member do
      post :pin
      post :unpin
    end
  end
  resources :notifications, only: [:index, :new, :create]

  resources :lectures, except: :destroy do
    get :overview, on: :collection
    post :register_attendance, on: :member
  end

  resources :exercises do
    publishable
    discardable
  end

  namespace :multiple_choices do
    resources :questionnaires, except: :show do
      publishable
      member do
        get :practice
        get :overview
        post :grade
        get :last
        post :toggle
      end
    end
  end

  namespace :tiny_cards do
    resources :decks do
      publishable
      resources :cards
      member do
        get :practice
      end
    end
  end

  namespace :peer_review do
    resources :challenges do
      get :messages, on: :collection
      get :meta_overview, on: :collection
      publishable
      get :flow, on: :member
      get :flow_overview, on: :collection
      get :bulk_download, on: :member
      get :duplicate, on: :member
      post :award, on: :member
      member do
        get :overview
        get :toggle
        get :purge
      end
      resources :solutions, only: [:new, :update, :show] do
        member do
          get :review
          post :save_review
          post :remove_attachment
          post :pick
          post :unpick
        end
        publishable
      end
      resources :reviews, only: [:new, :update, :destroy] do
        post :add_message, on: :member
      end
    end
  end

  resources :repos, only: [:index, :new, :create]
  get "repos/:user/:name" => "repos#show", as: :repo, constraints: { user: /[0-z.-]+/ }
  get "repos/:user/:name/grade" => "repos#grade", as: :grade, constraints: { user: /[0-z.-]+/ }
  resources :test_runs, only: [:show]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :repos do
        match :pending, via: [:get], on: :collection
        match :grade, via: [:post], on: :member
      end
    end
  end

  namespace :admin do
    resources :courses do
      member do
        get :toggle
        post :restore
        post :duplicate
        post :replicate
        post :rotate_password
      end
    end
    resources :users, only: [:index, :destroy, :edit, :update] do
      member do
        get :impersonate
        post :restore
      end
      collection do
        get :all
      end
    end
    resources :teachers, only: [:index, :destroy] do
      post :demote, on: :member
      post :register, on: :collection
    end
  end
end
