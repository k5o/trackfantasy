Rails.application.routes.draw do
  root 'landing#index'

  resources :users
  resources :sessions
  resources :payments

  get '/login', to: 'sessions#new', as: 'login'
  get '/signup', to: 'users#new', as: 'signup'
  get '/account', to: 'users#edit', as: 'account'
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/dashboard/fetch_dashboard_data', to: 'dashboard#fetch_dashboard_data', as: 'fetch_dashboard_data'
  get '/games', to: 'dashboard#games', as: 'games'
  get '/privacy', to: 'landing#privacy', as: 'privacy'
  get '/support', to: 'dashboard#support', as: 'support'
  post '/stripe/w3bh00k', to: 'stripe#webhook'
end