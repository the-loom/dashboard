Rails.application.routes.draw do
  root "pages#welcome"

  def publishable
    post :publish, on: :member
    post :unpublish, on: :member
  end

  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: :get

  get "/logout" => "sessions#destroy", as: :logout
  post "/admin_login" => "sessions#admin", as: :admin_login

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
    end
  end

  resources :teams, except: :show

  resources :teachers, only: [:index, :destroy] do
    post :join, on: :collection
    post :demote, on: :member
  end

  resources :suggestions, except: [:edit, :update] do
    get :dismissed, on: :collection
    post :restore, on: :member
    post :upvote, on: :member
    post :downvote, on: :member
    post :unvote, on: :member
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

  get "/teams/:nickname" => "teams#show", as: :team_profile, constraints: { nickname: /[0-z\.-]+/ }
  # resources :articles, param: :slug
  # https://stackoverflow.com/a/31060067/2661448

  resources :courses, only: [:index] do
    member do
      post :enroll
      get :switch
    end
  end

  resources :resource_categories, except: [:show]
  resources :resources, except: [:show] do
    publishable
  end

  resources :dashboard, only: :index
  resources :notifications, only: [:index, :new, :create]

  resources :lectures, except: :destroy do
    collection do
      get :overview
    end
  end

  resources :exercises do
    publishable
  end

  namespace :multiple_choices do
    resources :questionnaires do
      publishable
      member do
        get :practice
        get :overview
        post :grade
      end
      resources :questions, except: :index
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
      publishable
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
      resources :reviews, only: [:new, :update] do
        patch :assess, on: :member
      end
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
end
