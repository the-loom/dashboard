Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'pages#welcome'

  get '/auth/github', as: :login
  get '/auth/github/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout

  get '/profile' => 'users#show', as: :profile
  get '/u/:nickname' => 'users#show'

  get '/card' => 'users#card', as: :card

end
