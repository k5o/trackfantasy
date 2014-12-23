Rails.application.routes.draw do
  root 'landing#index'

  resources :users
  resources :sessions

  get '/login', to: 'sessions#new', as: 'login'
  get '/signup', to: 'users#new', as: 'signup'
  get '/payment', to: 'landing#payment', as: 'payment'
end