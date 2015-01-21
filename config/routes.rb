Rails.application.routes.draw do
  root 'landing#index'

  resources :users
  resources :sessions
  resources :reset_password, only: [:new, :show, :create, :update]

  get '/login', to: 'sessions#new', as: 'login'
  get '/signup', to: 'users#new', as: 'signup'
  get '/account', to: 'users#edit', as: 'account'
  post '/wipe_data', to: 'users#wipe_data', as: 'wipe_data'
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/dashboard/fetch_dashboard_data', to: 'dashboard#fetch_dashboard_data', as: 'fetch_dashboard_data'
  get '/games', to: 'dashboard#games', as: 'games'
  get '/dashboard/fetch_games_data', to: 'dashboard#fetch_games_data', as: 'fetch_games_data'
  get '/import', to: 'dashboard#import', as: 'import'
  get '/contact', to: 'dashboard#contact', as: 'contact'
  get '/privacy', to: 'landing#privacy', as: 'privacy'
  post '/csv_upload', to: 'csv#upload', as: 'csv_upload'
  post '/user_feedback', to: 'dashboard#user_feedback'

end
