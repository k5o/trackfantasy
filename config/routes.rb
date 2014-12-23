Rails.application.routes.draw do
  root 'landing#index'

  resources :users
  resources :sessions
  resources :payments

  get '/login', to: 'sessions#new', as: 'login'
  get '/signup', to: 'users#new', as: 'signup'
end