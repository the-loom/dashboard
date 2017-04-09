Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'pages#welcome'

  get '/auth/github', as: :login
  get '/auth/github/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout

  get '/profile' => 'users#show', as: :profile
  get '/u/:nickname' => 'users#show', as: :user_details
  get '/profile/edit' => 'users#edit', as: :edit_profile
  patch '/profile/edit' => 'users#update', as: :update_user
  get '/u/:nickname/impersonate' => 'users#impersonate', as: :impersonate_user
  get '/students' => 'users#index', as: :students
  get '/guests' => 'users#guests', as: :guests
  post '/u/bulk_edit' => 'users#bulk_edit', as: :bulk_edit_users
  post '/u/:nickname/comment' => 'users#comment', as: :comment_user


  get '/events/' => 'events#index', as: :events_list
  get '/events/new' => 'events#new', as: :new_event
  post '/events/new' => 'events#create', as: :create_event
  get '/events/:event_id/show' => 'events#show', as: :event_details
  get '/events/:event_id/register/:nickname' => 'events#register', as: :register_event

  get '/badges/' => 'badges#index', as: :badges_list
  get '/badges/new' => 'badges#new', as: :new_badge
  post '/badges/new' => 'badges#create', as: :create_badge
  get '/badges/:badge_id/show' => 'badges#show', as: :badge_details
  get '/badges/:badge_id/register/:nickname' => 'badges#register', as: :register_badge

end
