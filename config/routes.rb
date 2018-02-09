Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "pages#welcome"

  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  get "/logout" => "sessions#destroy", as: :logout

  get "/profile" => "users#show", as: :profile
  get "/u/:nickname" => "users#show", as: :user_details, constraints: { nickname: /[0-z\.]+/ }
  get "/profile/edit" => "users#edit", as: :edit_profile
  patch "/profile/edit" => "users#update", as: :update_user
  get "/profile/change_identity/:identity_id" => "users#change_identity", as: :change_identity
  get "/u/:nickname/impersonate" => "users#impersonate", as: :impersonate_user, constraints: { nickname: /[0-z\.]+/ }
  get "/students" => "users#index", as: :students
  get "/guests" => "users#guests", as: :guests
  post "/u/bulk_edit" => "users#bulk_edit", as: :bulk_edit_users
  post "/u/:nickname/comment" => "users#comment", as: :comment_user, constraints: { nickname: /[0-z\.]+/ }

  get "/events/" => "events#index", as: :events_list
  get "/events/new" => "events#new", as: :new_event
  post "/events/new" => "events#create", as: :create_event
  get "/events/:event_id/show" => "events#show", as: :event_details
  get "/events/:event_id/register/:nickname" => "events#register", as: :register_event, constraints: { nickname: /[0-z\.]+/ }

  get "/badges/" => "badges#index", as: :badges_list
  get "/badges/new" => "badges#new", as: :new_badge
  post "/badges/new" => "badges#create", as: :create_badge
  get "/badges/:badge_id/show" => "badges#show", as: :badge_details
  get "/badges/:badge_id/register/:nickname" => "badges#register", as: :register_badge, constraints: { nickname: /[0-z\.]+/ }

  get "/readings/" => "readings#index", as: :readings_list
  get "/readings/new" => "readings#new", as: :new_reading
  post "/readings/new" => "readings#create", as: :create_reading
  get "/readings/:slug/show" => "readings#show", as: :reading_details
  get "/readings/register" => "readings#prepare", as: :pre_register_reading
  post "/readings/register" => "readings#register", as: :register_reading

  get "/checkpoints/" => "checkpoints#index", as: :checkpoints_list
  get "/checkpoints/new" => "checkpoints#new", as: :new_checkpoint
  post "/checkpoints/new" => "checkpoints#create", as: :create_checkpoint
  get "/checkpoints/:checkpoint_id/show" => "checkpoints#show", as: :checkpoint_details
  post "/checkpoints/:checkpoint_id/register" => "checkpoints#register", as: :register_checkpoint

  get "/lectures/" => "lectures#index", as: :lectures_list
  get "/lectures/new" => "lectures#new", as: :new_lecture
  post "/lectures/new" => "lectures#create", as: :create_lecture
  get "/lectures/:lecture_id/show" => "lectures#show", as: :lecture_details
  post "/lectures/:lecture_id/register" => "lectures#register", as: :register_lecture

  get "/lectures/summary" => "lectures#summary", as: :attendance

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

  resources :teams, except: :show do
    patch :add_member
  end
  get "/teams/:nickname" => "teams#show", as: :team_profile, constraints: { nickname: /[0-z\.]+/ }

  resources :courses, only: [:index] do
    member do
      get :enroll
      get :switch
    end
  end

end
