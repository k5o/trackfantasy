Rails.application.routes.draw do
  root 'landing#index'

  resources :users
  resources :sessions
  resources :payments

  get '/login', to: 'sessions#new', as: 'login'
  get '/signup', to: 'users#new', as: 'signup'
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/privacy', to: 'landing#privacy', as: 'privacy'
  post '/stripe/w3bh00k', to: 'stripe#webhook'
end