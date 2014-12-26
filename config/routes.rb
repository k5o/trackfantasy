Rails.application.routes.draw do
  root 'landing#index'

  resources :users
  resources :sessions

  get '/login', to: 'sessions#new', as: 'login'
  get '/signup', to: 'users#new', as: 'signup'
  get '/privacy', to: 'landing#privacy', as: 'privacy'
end