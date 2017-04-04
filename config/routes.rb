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
  post '/u/bulk_edit' => 'users#bulk_edit', as: :bulk_edit_users

end
